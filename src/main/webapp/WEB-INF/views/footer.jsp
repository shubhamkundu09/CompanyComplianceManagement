<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
  /* ----- FOOTER ----- */
  footer {
    background: var(--black-soft);
    border-top: 2px solid var(--border-gold);
    padding: 50px 5% 30px;
  }

  .footer-inner {
    max-width: 1200px;
    margin: 0 auto;
    display: grid;
    grid-template-columns: 2fr 1fr 1fr;
    gap: 40px;
    padding-bottom: 30px;
    border-bottom: 1px solid var(--border-gold);
  }

  .footer-brand-name {
    font-family: var(--font-display);
    font-size: 1.3rem;
    letter-spacing: 0.12em;
    color: var(--gold);
    display: block;
    margin-top:10px;
  }

  .footer-brand-sub {
    font-size: 0.55rem;
    letter-spacing: 0.25em;
    text-transform: uppercase;
    color: white;
    display: block;
    margin: 6px 0;
  }

  .footer-brand-desc {

    font-size: 0.85rem;
    line-height: 1.7;
    color: var(--gray-1);
  }

  .footer-col-title {

    font-size: 0.6rem;
    letter-spacing: 0.3em;
    text-transform: uppercase;
    color: var(--gold);
    margin-bottom: 16px;
  }

  .footer-links {
    list-style: none;
    display: flex;
    flex-direction: column;
    gap: 8px;
  }

  .footer-links a {

    font-size: 0.85rem;
    color: var(--gray-1);
    text-decoration: none;
    transition: color 0.3s;
  }

  .footer-links a:hover {
    color: var(--gold);
  }

  .footer-bottom {
    max-width: 1200px;
    margin: 24px auto 0;
    display: flex;
    justify-content:  center;
    align-items: center;
    flex-wrap: wrap;
    gap: 12px;
  }

  .footer-copy {
    font-size: 0.6rem;
    letter-spacing: 0.15em;
    color: var(--gray-2);
  }

  @media (max-width: 700px) {
    .footer-inner { grid-template-columns: 1fr; gap: 28px; }
  }
</style>

<!-- ========== FOOTER ========== -->
<footer>
  <div class="footer-inner">
    <div>
     <div class="logo"><img src="${baseUrl}/vnextimages/companyfiles/logo.png" alt="VNext Legal"></div>
      <span class="footer-brand-name">VNext Legal LLP</span>
      <span class="footer-brand-sub">Advocates &middot; Solicitors &middot; Consultants</span>
      <p class="footer-brand-desc">Protecting your interests, empowering your decisions. A multidisciplinary legal consultancy delivering trusted solutions with professionalism, integrity, and excellence.</p>
    </div>
    <div>
      <div class="footer-col-title">Services</div>
      <ul class="footer-links">
        <li><a href="service">Surveillance Services</a></li>
        <li><a href="service">Check on Check</a></li>
        <li><a href="service">Legal Retainers</a></li>
        <li><a href="service">Facilitator Services</a></li>
      </ul>
    </div>
    <div>
      <div class="footer-col-title">Company</div>
      <ul class="footer-links">
        <li><a href="about">About Us</a></li>
        <li><a href="about">Our Vision</a></li>
        <li><a href="about">Our Mission</a></li>
        <li><a href="about">Why Choose Us</a></li>
        <li><a href="contact">Contact</a></li>
      </ul>
    </div>
  </div>
  <div class="footer-bottom">
    <div class="footer-copy">&copy; 2026 VNext Legal. All rights reserved.</div>
  </div>
</footer>
