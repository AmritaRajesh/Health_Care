package com.hms.filter;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * AuthFilter — runs on every request.
 *
 * Rules:
 *  1. Public URLs (home, about, contact, login, register, forgot, static assets)
 *     → always allowed through, no session check.
 *
 *  2. Protected URLs (/admin/*, /doctor/*, /patient/*)
 *     → must have a valid session with "userObj".
 *     → if not, redirect to /login.
 *     → if logged in but wrong role, redirect to own dashboard.
 *
 *  3. /login and /register while already logged in
 *     → redirect straight to the user's dashboard (no re-login needed).
 */
@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig config) throws ServletException {}

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  request  = (HttpServletRequest)  req;
        HttpServletResponse response = (HttpServletResponse) res;

        String contextPath = request.getContextPath();          // e.g. /HospitalManagementMaven
        String uri         = request.getRequestURI();           // full path
        // Strip context path to get the relative path
        String path = uri.substring(contextPath.length());      // e.g. /login, /patient/dashboard

        // ── 1. Always allow static resources ──────────────────────────────────
        if (path.startsWith("/css/")
                || path.startsWith("/js/")
                || path.startsWith("/images/")
                || path.startsWith("/fonts/")
                || path.endsWith(".css")
                || path.endsWith(".js")
                || path.endsWith(".png")
                || path.endsWith(".jpg")
                || path.endsWith(".ico")) {
            chain.doFilter(req, res);
            return;
        }

        HttpSession session = request.getSession(false);   // don't create a new session
        com.hms.model.User user = (session != null)
                ? (com.hms.model.User) session.getAttribute("userObj")
                : null;

        boolean isLoggedIn = (user != null);

        // ── 2. Public pages — always accessible ───────────────────────────────
        boolean isPublic = path.equals("/")
                || path.equals("/home")
                || path.equals("/about")
                || path.equals("/contact")
                || path.equals("/login")
                || path.equals("/register")
                || path.equals("/patientRegister")
                || path.equals("/forgot")
                || path.startsWith("/AddPatientServlet");

        // ── 3. Already logged in + trying to reach login/register ─────────────
        //    → send them straight to their dashboard
        if (isLoggedIn && (path.equals("/login") || path.equals("/register"))) {
            response.sendRedirect(contextPath + getDashboard(user.getRole()));
            return;
        }

        // ── 4. Public page — let through ──────────────────────────────────────
        if (isPublic) {
            chain.doFilter(req, res);
            return;
        }

        // ── 5. Protected page — must be logged in ─────────────────────────────
        if (!isLoggedIn) {
            // Save the originally requested URL so we can redirect back after login
            request.getSession(true).setAttribute("redirectAfterLogin", uri);
            response.sendRedirect(contextPath + "/login");
            return;
        }

        // ── 6. Role-based access control ──────────────────────────────────────
        String role = user.getRole();

        if (path.startsWith("/admin/") && !"admin".equals(role)) {
            response.sendRedirect(contextPath + getDashboard(role));
            return;
        }
        if (path.startsWith("/doctor/") && !"doctor".equals(role)) {
            response.sendRedirect(contextPath + getDashboard(role));
            return;
        }
        if (path.startsWith("/patient/") && !"patient".equals(role)) {
            response.sendRedirect(contextPath + getDashboard(role));
            return;
        }

        // ── 7. All checks passed — continue ───────────────────────────────────
        chain.doFilter(req, res);
    }

    /** Returns the dashboard URL for a given role. */
    private String getDashboard(String role) {
        switch (role) {
            case "admin":   return "/admin/dashboard";
            case "doctor":  return "/doctor/dashboard";
            default:        return "/patient/dashboard";
        }
    }

    @Override
    public void destroy() {}
}
