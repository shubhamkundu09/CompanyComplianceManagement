<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
<title>VNext Legal — Advocates, Solicitors &amp; Consultants</title>
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,500;0,600;1,300;1,400&family=Didact+Gothic&family=Cinzel:wght@400;500;600&display=swap"
      rel="stylesheet">
 <style>
          *,
          *::before,
          *::after {
               box-sizing: border-box;
               margin: 0;
               padding: 0;
          }

          :root {
               --gold: #C9A84C;
               --gold-light: #E8C97A;
               --gold-pale: #F5E6B8;
               --gold-dark: #8B6914;
               --black: #0A0A0A;
               --black-soft: #111111;
               --black-mid: #1A1A1A;
               --black-card: #141414;
               --white: #FAFAF8;
               --white-soft: #F0EDE6;
               --cream: #f7f3ec;
               --cream-soft: #ede8de;
               --cream-mid: #d8d0c0;
               --gray-1: #888880;
               --gray-2: #555550;
               --border-gold: rgba(201, 168, 76, 0.25);
               --border-gold-strong: rgba(201, 168, 76, 0.6);
               --font-display: 'Cinzel', serif;
               --font-serif: 'Cormorant Garamond', serif;
               --font-body: 'Didact Gothic', sans-serif;
          }

          html {
               scroll-behavior: smooth;
          }

          body {
               background: var(--black);
               color: var(--white);
               font-family: var(--font-body);
               font-size: 15px;
               line-height: 1.75;
               overflow-x: hidden;
          }

          body::before {
               content: '';
               position: fixed;
               inset: 0;
               background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.04'/%3E%3C/svg%3E");
               pointer-events: none;
               z-index: 0;
               opacity: 0.5;
          }

                   /* SIDEBAR (mobile navigation) */
          .sidebar-nav {
               position: fixed;
               top: 0;
               right: -100%;
               width: 85%;
               max-width: 360px;
               height: 100vh;
               background: rgba(10, 10, 10, 0.98);
               backdrop-filter: blur(24px);
               z-index: 300;
               transition: right 0.4s cubic-bezier(0.4, 0, 0.2, 1);
               display: flex;
               flex-direction: column;
               padding: 32px 28px;
               border-left: 1px solid var(--border-gold);
               box-shadow: -8px 0 32px rgba(0, 0, 0, 0.6);
          }

          .sidebar-nav.open {
               right: 0;
          }

          .sidebar-header {
               display: flex;
               justify-content: space-between;
               align-items: center;
               margin-bottom: 6px;
               border-bottom: 1px solid var(--border-gold);
               padding-bottom: 11px;
          }

          .sidebar-header .logo img {
               height: 74px;
          }

          .close-sidebar {
               background: transparent;
               border: 1px solid var(--border-gold-strong);
               width: 40px;
               height: 40px;
               border-radius: 50%;
               display: flex;
               align-items: center;
               justify-content: center;
               cursor: pointer;
               transition: all 0.3s;
               color: var(--gold);
               font-size: 1.4rem;
               font-weight: 300;
          }

          .close-sidebar:hover {
               background: var(--gold);
               color: var(--black);
               border-color: var(--gold);
          }

          .sidebar-links {
               display: flex;
               flex-direction: column;
               gap: 20px;
               flex: 1;
          }

          .sidebar-links a {
               font-family: var(--font-body);
               font-size: 0.7rem;
               letter-spacing: 0.2em;
               text-transform: uppercase;
               color: var(--gray-1);
               text-decoration: none;
               padding: 8px 0;
               border-bottom: 1px solid var(--border-gold);
               transition: color 0.3s, padding-left 0.2s;
          }

          .sidebar-links a:hover {
               color: var(--gold);
               padding-left: 8px;
          }

          .sidebar-cta {
               margin-top: 32px;
               font-family: var(--font-body);
               font-size: 0.8rem;
               letter-spacing: 0.1em;
               text-transform: uppercase;
               padding: 14px 0;
               text-align: center;
               background: var(--gold);
               color: var(--black);
               border: none;
               border-radius: 40px;
               cursor: pointer;
               text-decoration: none;
               display: inline-block;
               transition: all 0.3s;
               font-weight: 600;
          }

          .sidebar-cta:hover {
               background: var(--gold-light);
               transform: translateY(-2px);
          }

          .sidebar-overlay {
               position: fixed;
               inset: 0;
               background: rgba(0, 0, 0, 0.7);
               z-index: 250;
               opacity: 0;
               visibility: hidden;
               transition: opacity 0.3s, visibility 0.3s;
          }

          .sidebar-overlay.active {
               opacity: 1;
               visibility: visible;
          }

          /* HERO */
          .hero {
               min-height: 80vh;
               display: flex;
               align-items: center;
               justify-content: center;
               text-align: center;
               padding: 120px 5% 56px;
               overflow: hidden;
               background-image: url("./images/legal.png");
               background-position: center;
               background-size: cover;
               position: relative;
          }

          .hero::before {
               content: "";
               position: absolute;
               width: 100%;
               height: 100%;
               top: 0;
               left: 0;
               background: linear-gradient(rgba(10, 10, 10, 0.79), #0a0a0ad1, #111111c7);
          }

          .hero-grid {
               position: absolute;
               inset: 0;
               background-image: linear-gradient(rgba(201, 168, 76, 0.04) 1px, transparent 1px),
                    linear-gradient(90deg, rgba(201, 168, 76, 0.04) 1px, transparent 1px);
               background-size: 80px 80px;
               pointer-events: none;
          }

          .hero-orb {
               position: absolute;
               border-radius: 50%;
               filter: blur(80px);
               pointer-events: none;
          }

          .hero-orb-1 {
               width: 500px;
               height: 500px;
               background: radial-gradient(circle, rgba(201, 168, 76, 0.08) 0%, transparent 70%);
               top: 10%;
               left: -10%;
               animation: orbDrift1 12s ease-in-out infinite;
          }

          .hero-orb-2 {
               width: 400px;
               height: 400px;
               background: radial-gradient(circle, rgba(201, 168, 76, 0.06) 0%, transparent 70%);
               bottom: 10%;
               right: -5%;
               animation: orbDrift2 15s ease-in-out infinite;
          }

          @keyframes orbDrift1 {

               0%,
               100% {
                    transform: translate(0, 0);
               }

               50% {
                    transform: translate(40px, 30px);
               }
          }

          @keyframes orbDrift2 {

               0%,
               100% {
                    transform: translate(0, 0);
               }

               50% {
                    transform: translate(-30px, -40px);
               }
          }

          .hero-content {
               position: relative;
               z-index: 2;
               max-width: 900px;
          }

          .hero-tag {
               display: inline-flex;
               align-items: center;
               gap: 12px;
               font-family: var(--font-body);
               font-size: 0.7rem;
               letter-spacing: 0.35em;
               text-transform: uppercase;
               color: var(--gold);
               margin-bottom: 2rem;
               font-weight: 900;
               flex-wrap: wrap;
               justify-content: center;
          }

          .hero-tag::before,
          .hero-tag::after {
               content: '';
               display: block;
               width: 30px;
               height: 1px;
               background: var(--gold);
          }

          .hero-title {
               font-family: var(--font-display);
               font-size: clamp(2.6rem, 8vw, 6.5rem);
               font-weight: 700;
               letter-spacing: 0.06em;
               line-height: 1.05;
               color: var(--white);
          }

          .hero-title .gold {
               color: var(--gold);
          }

          .hero-subtitle {
               font-family: var(--font-serif);
               font-size: clamp(0.9rem, 2.5vw, 1.25rem);
               font-weight: 500;
               font-style: italic;
               color: white;
               letter-spacing: 0.08em;
               padding: 0 1rem;
          }

          .hero-divider {
               display: flex;
               align-items: center;
               justify-content: center;
               gap: 16px;
               margin: 1rem auto;
               flex-wrap: wrap;
          }

          .hero-divider-line {
               width: 60px;
               height: 1px;
               background: var(--border-gold-strong);
          }

          .hero-divider-diamond {
               width: 10px;
               height: 10px;
               border: 1px solid var(--gold);
               transform: rotate(45deg);
               animation: spin 6s linear infinite;
          }

          @keyframes spin {
               to {
                    transform: rotate(45deg) rotate(360deg);
               }
          }

          .hero-desc {
               font-size: clamp(0.9rem, 1.8vw, 1.2rem);
               line-height: 1.8;
               color: rgba(250, 250, 248, 0.7);
               max-width: 680px;
               margin: 0 auto 2rem;
               padding: 0 1rem;
          }

          .hero-btns {
               display: flex;
               gap: 16px;
               justify-content: center;
               flex-wrap: wrap;
          }

          .btn-primary {
               font-family: var(--font-serif);
               font-size: 0.8rem;
               letter-spacing: 0.15em;
               font-weight: 600;
               text-transform: uppercase;
               padding: 14px 32px;
               background: var(--gold);
               color: var(--black);
               border: none;
               cursor: pointer;
               text-decoration: none;
               display: inline-flex;
               align-items: center;
               gap: 10px;
               position: relative;
               overflow: hidden;
               transition: transform 0.3s, box-shadow 0.3s;
               border-radius: 15px;
          }

          .btn-primary::before {
               content: '';
               position: absolute;
               inset: 0;
               background: var(--gold-light);
               transform: translateX(-101%);
               transition: transform 0.4s cubic-bezier(0.4, 0, 0.2, 1);
          }

          .btn-primary:hover::before {
               transform: translateX(0);
          }

          .btn-primary:hover {
               box-shadow: 0 8px 30px rgba(201, 168, 76, 0.3);
               transform: translateY(-2px);
          }

          .btn-primary span {
               position: relative;
               z-index: 1;
          }

          .btn-secondary {
               font-family: var(--font-body);
               font-size: 0.7rem;
               letter-spacing: 0.25em;
               text-transform: uppercase;
               padding: 14px 32px;
               background: transparent;
               color: var(--white);
               border: 1px solid rgba(250, 250, 248, 0.691);
               cursor: pointer;
               text-decoration: none;
               display: inline-flex;
               align-items: center;
               gap: 10px;
               transition: all 0.3s;
               border-radius: 15px;
          }

          .btn-secondary:hover {
               border-color: var(--gold);
               color: var(--gold);
          }

          /* MARQUEE */
          .marquee-wrap {
               border-top: 1px solid var(--border-gold);
               border-bottom: 1px solid var(--border-gold);
               padding: 12px 0;
               overflow: hidden;
               background: var(--black-soft);
          }

          .marquee-track {
               display: flex;
               gap: 40px;
               width: max-content;
               animation: marquee 30s linear infinite;
          }

          .marquee-item {
               font-family: var(--font-body);
               font-size: 0.6rem;
               letter-spacing: 0.25em;
               text-transform: uppercase;
               color: var(--gray-1);
               white-space: nowrap;
               display: flex;
               align-items: center;
               gap: 40px;
          }

          .marquee-item::after {
               content: '◆';
               color: var(--gold);
               font-size: 0.4rem;
          }

          @keyframes marquee {
               0% {
                    transform: translateX(0);
               }

               100% {
                    transform: translateX(-50%);
               }
          }

          /* ABOUT */
          .about {
               padding: 60px 5%;
               background: var(--cream);
          }

          .about-inner {
               max-width: 1200px;
               margin: 0 auto;
               display: grid;
               grid-template-columns: 1fr 1fr;
               gap: 50px;
               align-items: center;
          }

          .about .section-title {
               color: var(--black);
               font-size: clamp(1.8rem, 4vw, 2.8rem);
          }

          .about .section-label {
               color: var(--gold-dark);
          }

          .about-text-body {
               font-family: var(--font-serif);
               font-size: 1.2rem;
               line-height: 1.8;
               color: #4a453e;
               margin-bottom: 2rem;
          }

          .about-visual {
               position: relative;
          }

          .about-img-wrap img {
               width: 100%;
               aspect-ratio: 5/6;
               display: block;
               border: 1px solid rgba(201, 168, 76, 0.3);
          }

          .about-accent-box {
               position: absolute;
               bottom: -20px;
               right: -20px;
               background: var(--gold);
               padding: 16px 22px;
               width: 150px;
               z-index: 2;
          }

          .about-accent-box .num {
               font-family: var(--font-display);
               font-size: 2rem;
               color: var(--black);
               line-height: 1;
               display: block;
          }

          .about-accent-box .lbl {
               font-size: 0.55rem;
               letter-spacing: 0.15em;
               text-transform: uppercase;
               color: rgba(13, 13, 11, 0.7);
               margin-top: 6px;
          }

          .trust-list {
               display: flex;
               flex-direction: column;
               gap: 1px;
          }

          .trust-item {
               display: flex;
               align-items: flex-start;
               gap: 14px;
               padding: 14px 0;
               border-bottom: 1px solid rgba(201, 168, 76, 0.66);
               transition: all 0.3s;
          }

          .trust-icon {
               width: 36px;
               height: 36px;
               flex-shrink: 0;
               border: 1px solid rgba(201, 168, 76, 0.4);
               display: flex;
               align-items: center;
               justify-content: center;
               background: rgba(206, 168, 61, 0.82);
          }

          .trust-icon svg {
               width: 20px;
               height: 18px;
               stroke: var(--gold-dark);
               fill: none;
               stroke-width: 1.5;
          }

          .trust-text strong {
               font-family: var(--font-body);
               font-size: 0.88rem;
               letter-spacing: 0.08em;
               color: #1a1814;
               display: block;
          }

          .trust-text span {
               /* font-family: var(--font-serif); */
               font-size: 0.99rem;
               color: #6b6458;
          }

          /* SERVICES SECTION */
          .svc-section {
               background: #111;
               padding: 60px 5%;
          }

          .svc-label {
               text-align: center;
               font-size: 11px;
               letter-spacing: 3px;
               color: #c9a84c;
               text-transform: uppercase;
               margin-bottom: 12px;
          }

          .svc-title {
               text-align: center;
               font-size: clamp(1.8rem, 5vw, 2.5rem);
               font-weight: 700;
               color: #fff;
               line-height: 1.2;
               margin-bottom: 12px;
          }

          .svc-title span {
               color: #c9a84c;
          }

          .svc-divider {
               width: 60px;
               height: 2px;
               background: #c9a84c;
               margin: 0 auto 14px;
          }

          .svc-subtitle {
               text-align: center;
               color: #e2d4d4;
               font-size: 17px;
               margin-bottom: 40px;
               max-width: 500px;
               margin-left: auto;
               margin-right: auto;
               padding: 0 1rem;
          }

          .svc-grid {
               display: grid;
               grid-template-columns: repeat(4, 1fr);
               gap: 20px;
          }

          .svc-card {
               position: relative;
               overflow: hidden;
               cursor: pointer;
               height: 340px;
               border-radius: 8px;
          }

          .svc-card img {
               width: 100%;
               height: 100%;
               object-fit: cover;
               display: block;
               filter: brightness(0.45);
               transition: filter 0.4s, transform 0.4s;
          }

          .svc-card:hover img {
               filter: brightness(0.25);
               transform: scale(1.05);
          }

          .svc-card-body {
               position: absolute;
               inset: 0;
               display: flex;
               flex-direction: column;
               justify-content: flex-end;
               padding: 20px 18px;
          }

          .svc-num {
               font-size: 11px;
               letter-spacing: 2px;
               color: #c9a84c;
               margin-bottom: 6px;
          }

          .svc-icon {
               width: 40px;
               height: 40px;
               border: 1.5px solid #c9a84c;
               border-radius: 50%;
               display: flex;
               align-items: center;
               justify-content: center;
               margin-bottom: 10px;
          }

          .svc-icon svg {
               width: 18px;
               height: 18px;
               stroke: #c9a84c;
               fill: none;
               stroke-width: 1.8;
          }

          .svc-name {
               font-size: 20px;
               font-weight: 700;
               color: #fff;
               border-bottom: 1px solid #c9a84c;
               display: inline-block;
               padding-bottom: 4px;
               margin-bottom: 6px;
          }

          .svc-desc {
               font-size: 17px;
               color: #fffefe;
               line-height: 1.6;
               margin-bottom: 8px;
               max-height: 0;
               overflow: hidden;
               transition: max-height 0.4s ease, opacity 0.4s;
               opacity: 0;
          }

          .svc-card:hover .svc-desc {
               max-height: 80px;
               opacity: 1;
          }

          .svc-list {
               list-style: none;
               max-height: 0;
               overflow: hidden;
               transition: max-height 0.4s ease, opacity 0.4s;
               opacity: 0;
          }

          .svc-card:hover .svc-list {
               max-height: 140px;
               opacity: 1;
          }

          .svc-list li {
               font-size: 13px;
               color: #d1ae4f;
               padding: 2px 0;
               padding-left: 20px;
               position: relative;
          }

          .svc-list li::before {
               content: '→';
               position: absolute;
               left: 2px;
               color: #c9a84c;
          }

          /* ========== RESPONSIVE ========== */



 @media (max-width: 1024px) {
    .svc-grid { grid-template-columns: repeat(2, 1fr); gap: 15px; }
    .svc-card { height: 450px; }

    .about-inner    { grid-template-columns: 1fr; gap: 40px; }
    .steps-track    { flex-direction: column; align-items: center; }
    .steps-track::before { display: none; }
    .step           { flex-direction: row; text-align: left; gap: 20px; width: 100%; margin-bottom: 25px; }
    .step-node      { margin-bottom: 0; flex-shrink: 0; }
    .why-inner      { grid-template-columns: 1fr; gap: 40px; }
     .svc-list li{
     font-size:13px;}
}

@media (max-width: 900px) {
    .svc-card { height: 460px; }
}

@media (max-width: 768px) {
    .hero           { padding: 110px 5% 40px; }
    .hero-tag       { font-size: 0.55rem; letter-spacing: 0.2em; }
    .hero-tag::before, .hero-tag::after { width: 20px; }

    .svc-grid       { grid-template-columns: 1fr; max-width: 400px; margin: 0 auto; }
    .svc-card       { height: 440px; }
    .svc-name       { font-size: 18px; }
    .svc-desc       { font-size: 15px; }
    .svc-list li    { font-size: 14px; }

    .svc-card:hover .svc-desc,
    .svc-card.active .svc-desc { max-height: 120px; }

    .svc-card:hover .svc-list,
    .svc-card.active .svc-list { max-height: 180px; }

    .about-accent-box { bottom: -52px; right: -8px; padding: 12px 18px; width: 130px; }
    .about-accent-box .num { font-size: 1.6rem; }
}

@media (max-width: 580px) {
    .svc-card       { height: 460px; }

    .popup-body     { padding: 20px 22px 28px; }
    .form-row-dual  { grid-template-columns: 1fr; gap: 16px; }
    .popup-header   { padding: 18px 22px 12px; }
    .popup-title    { font-size: 1.4rem; }
}

@media (max-width: 480px) {
    .svc-card       { height: 480px; }
    .svc-desc       { font-size: 14px; }
    .svc-list li    { font-size: 13px; }

    .svc-card:hover .svc-desc,
    .svc-card.active .svc-desc { max-height: 140px; }

    .svc-card:hover .svc-list,
    .svc-card.active .svc-list { max-height: 190px; }

    .hero-btns      { flex-direction: column; align-items: stretch; }
    .btn-primary, .btn-secondary { text-align: center; justify-content: center; }
    .trust-item     { gap: 12px; }
    .why-card       { flex-direction: column; align-items: flex-start; }
    .cta-eyebrow::before, .cta-eyebrow::after { width: 20px; }
    .popup-header   { padding: 14px 20px 10px; }
    .popup-body     { padding: 16px 20px 24px; }
}





          /* APPROACH */
          .approach {
               padding: 60px 5%;
               background: var(--black);
               border-top: 1px solid var(--border-gold);
          }

          .approach-inner {
               max-width: 1200px;
               margin: 0 auto;
          }

          .steps-track {
               position: relative;
               display: flex;
               gap: 0;
               flex-wrap: wrap;
          }

          .steps-track::before {
               content: '';
               position: absolute;
               top: 36px;
               left: 36px;
               right: 36px;
               height: 1px;
               background: var(--border-gold);
               z-index: 0;
          }

          .step {
               flex: 1;
               display: flex;
               flex-direction: column;
               align-items: center;
               text-align: center;
               position: relative;
               z-index: 1;
               padding: 0 12px;
          }

          .step-node {
               width: 65px;
               height: 65px;
               border: 2px solid var(--gold-dark);
               background: var(--black);
               display: flex;
               align-items: center;
               justify-content: center;
               margin-bottom: 20px;
               transition: all 0.4s;
          }

          .step:hover .step-node {
               background: var(--gold);
               border-color: var(--gold);
               transform: scale(1.05);
          }

          .step-node-num {
               font-family: var(--font-display);
               font-size: 0.9rem;
               color: var(--gold);
          }

          .step:hover .step-node-num {
               color: var(--black);
          }

          .step-title {
               /* font-family: var(--font-display); */
               font-size: 1.2rem;
               letter-spacing: 0.12em;
               color: var(--gold);
               margin-bottom: 6px;
               font-weight: 700;
          }

          .step-desc {
               /* font-family: var(--font-display); */
               font-size: 0.89rem;
               color: white;
               line-height: 1.6;
          }

          /* WHY CHOOSE */
          .why {
               background: var(--cream);
               padding: 60px 5%;
          }

          .why-inner {
               max-width: 1200px;
               margin: 0 auto;
               display: grid;
               grid-template-columns: 1fr 1fr;
               gap: 50px;
               align-items: start;
          }

          .section-label {
               display: flex;
               align-items: center;
               gap: 10px;
               font-family: var(--font-body);
               font-size: 10px;
               letter-spacing: 0.2em;
               text-transform: uppercase;
               color: var(--gold-dark);
          }

          .section-label span {
               display: block;
               width: 28px;
               height: 1px;
               background: var(--gold);
          }

          .section-title {
               font-family: var(--font-display);
               font-size: clamp(1.6rem, 4vw, 2.5rem);
               font-weight: 600;
               line-height: 1.25;
               color: #1a1208;
          }

          .gold-line {
               width: 52px;
               height: 2px;
               background: linear-gradient(90deg, var(--gold), var(--gold-pale));
               margin: 16px 0;
          }

          .why-img-wrap {
               border-radius: 14px;
               overflow: hidden;
               border: 0.5px solid var(--border-gold-strong);
          }

          .why-img-wrap img {
               width: 100%;
               height: auto;
               max-height: 320px;
               object-fit: cover;
               display: block;
               transition: transform 0.6s ease;
          }

          .why-right {
               display: flex;
               flex-direction: column;
               gap: 16px;
          }

          .why-card {
               background: #fff;
               border: 0.5px solid rgba(186, 143, 21, 0.76);
               border-radius: 14px;
               padding: 18px 20px;
               display: flex;
               align-items: flex-start;
               gap: 16px;
               transition: all 0.25s;
               box-shadow: #c9a84c9e 0px 3px 6px, rgba(192, 149, 20, 0.22) 0px 3px 6px;
          }

          .why-card:hover {
               transform: translateY(-2px);
          }

          .why-icon-wrap {
               width: 44px;
               height: 44px;
               flex-shrink: 0;
               border-radius: 10px;
               background: var(--cream);
               border: 0.5px solid var(--border-gold-strong);
               display: flex;
               align-items: center;
               justify-content: center;
          }

          .why-icon-wrap svg {
               width: 20px;
               height: 20px;
               fill: none;
               stroke: var(--gold-dark);
               stroke-width: 1.6;
          }

          .why-content h3 {
               font-family: var(--font-display);
               font-size: 16px;
               font-weight: bolder;
               letter-spacing: 0.04em;
              color: #11100c;
               margin-bottom: 6px;
          }

          .why-content p {
               /* font-family: var(--font-serif); */
               font-size: 14px;
               line-height: 1.6;
               color: #6b5c3e;
          }

          /* CTA */
          .cta-section {
               padding: 60px 5%;
               background: var(--black);
               border-top: 1px solid var(--border-gold);
               text-align: center;
          }

          .cta-inner {
               max-width: 700px;
               margin: 0 auto;
          }

          .cta-eyebrow {
               font-family: var(--font-body);
               font-size: 0.6rem;
               letter-spacing: 0.4em;
               text-transform: uppercase;
               color: var(--gold);
               margin-bottom: 20px;
               display: flex;
               align-items: center;
               justify-content: center;
               gap: 12px;
               flex-wrap: wrap;
          }

          .cta-eyebrow::before,
          .cta-eyebrow::after {
               content: '';
               width: 30px;
               height: 1px;
               background: var(--gold);
          }

          .cta-title {
               font-family: var(--font-display);
               font-size: clamp(1.8rem, 5vw, 3rem);
               font-weight: 400;
               letter-spacing: 0.02em;
               line-height: 1.2;
               color: var(--white);
               margin-bottom: 1rem;
          }

          .cta-sub {
               /* font-family: var(--font-serif); */
               font-size: 1.1rem;
               font-style: italic;
               color: rgba(255, 255, 255, 0.793);
               margin-bottom: 2rem;
               padding: 0 1rem;
          }

          /* FOOTER */
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
               margin-top: 20px;
          }

          .footer-brand-sub {
               font-size: 0.69rem;
               letter-spacing: 0.25em;
               text-transform: uppercase;
               color: white;
               display: block;
               margin: 6px 0;
          }

          .footer-brand-desc {
               /* font-family: var(--font-serif); */
               font-size: 0.89rem;
               line-height: 1.7;
               color: var(--gray-1);
          }

          .footer-col-title {
               /* font-family: var(--font-body); */
               font-size: 0.9rem;
               font-weight: 700;
               letter-spacing: 0.2em;
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
               /* font-family: var(--font-serif); */
               font-size: 0.87rem;
               color: rgba(214, 211, 211, 0.769);
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
               justify-content: space-between;
               align-items: center;
               flex-wrap: wrap;
               gap: 12px;
          }

          .footer-copy {
               font-size: 0.6rem;
               letter-spacing: 0.15em;
               color: var(--gray-2);
          }



  /* ========== POPUP OVERLAY ========== */
  .popup-overlay {
    position: fixed;
    inset: 0;
    z-index: 2000;
   background: rgb(6 6 5 / 22%);
    backdrop-filter: blur(23px);
    display: flex;
    align-items: center;
    justify-content: center;
    opacity: 0;
    pointer-events: none;
    transition: opacity 0.4s ease;
    padding: 20px;
  }

  .popup-overlay.open {
    opacity: 1;
    pointer-events: all;
  }


  .popup {
  background: #f4f2ef;
  border: 2px solid #734f07;
  border-radius: 36px;
  max-width: 620px;
  width: 80%;
  box-shadow: 0 32px 64px rgba(0, 0, 0, 0.12), 0 0 0 1px rgba(200, 168, 107, 0.15) inset;
  transform: scale(0.96);
  transition: transform 0.35s cubic-bezier(0.2, 0.9, 0.3, 1.1), opacity 0.25s;
  opacity: 0;
  max-height: 95vh;
  overflow-y: hidden;
}

.popup-overlay.open .popup {
  transform: scale(1);
  opacity: 1;
}

.popup-header {
  padding: 8px 32px 10px;
  border-bottom: 1px solid #d59108;
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 12px;
}

.popup-title {
  font-family: var(--font-serif);
  font-size: 1.89rem;
  font-weight: 700;
  letter-spacing: -0.2px;
  background: linear-gradient(135deg, #b8893f, #c8a86b);
  background-clip: text;
  -webkit-background-clip: text;
  color: transparent;
}

.popup-close {
  width: 40px;
  height: 40px;
  border: 2px solid var(--gold-dark);
  background: rgba(237, 192, 109, 0.08);
  border-radius: 50%;
  cursor: pointer;
  color: var(--gold-primary);
  font-size: 1.9rem;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.25s;
  flex-shrink: 0;
}

.popup-close:hover {
  background: rgba(200, 168, 107, 0.18);
  color: #b8893f;
  transform: rotate(90deg);
  border-color: #c8a86b;
}

.popup-body {
  padding: 10px 32px 20px;
}

.form-group {
  margin-bottom: 20px;
}

.form-row-dual {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
  margin-bottom: 20px;
}

.input-wrapper {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.form-label {
  /* font-family: var(--font-sans); */
  font-size: 1rem;
  font-weight: 900;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: #965903;
  margin-left: 6px;
}


.form-input,
.form-textarea {
  background: #f0eee8;
  border: 1px solid #f1b130;
  color: #1c1a18;
  padding: 12px 16px;
  width: 100%;
  border-radius: 20px;
  font-size: 0.9rem;
  font-family: var(--font-sans);
  transition: var(--transition-smooth);
  outline: none;
}

.form-input::placeholder,
.form-textarea::placeholder {
  color: #504f4d;
}

.form-input:focus,
.form-textarea:focus {
  border-color: #c8a86b;
  background: #fff;
  box-shadow: 0 0 0 3px rgba(200, 168, 107, 0.18);
}

.form-textarea {
  min-height: 100px;
  resize: vertical;
}

.error-message {
  font-size: 0.7rem;
  color: #c0563f;
  margin-top: 4px;
  margin-left: 12px;
  display: flex;
  align-items: center;
  gap: 4px;
  font-weight: 500;
  min-height: 1em;
}

.form-submit {
  width: 100%;
  padding: 16px 20px;
  background: linear-gradient(100deg, var(--gold-dark),var(--gold-dark));
  border: none;
  font-family: var(--font-sans);
  font-weight: 900;
  font-size: 0.95rem;
  letter-spacing: 0.2em;
  text-transform: uppercase;
  border-radius: 44px;
  margin-top: 18px;
  cursor: pointer;
  transition: all 0.3s;
  color: black;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
}

.form-submit:hover {
  background: linear-gradient(100deg, #d4b97e, #c8a86b);
  transform: translateY(-2px);
  box-shadow: 0 12px 24px rgba(200, 168, 107, 0.3);
  letter-spacing: 0.27em;
}

.form-submit:active { transform: translateY(1px); }



  /* WHATSAPP FLOAT BUTTON */
          .whatsapp-float {
               position: fixed;
               bottom: 28px;
               right: 28px;
               z-index: 500;
               width: 56px;
               height: 56px;
               background: #25D366;
               border-radius: 50%;
               display: flex;
               align-items: center;
               justify-content: center;
               box-shadow: 0 4px 20px rgba(37, 211, 102, 0.45);
               text-decoration: none;
               transition: transform 0.3s, box-shadow 0.3s;
          }

          .whatsapp-float:hover {
               transform: scale(1.1) translateY(-2px);
               box-shadow: 0 8px 28px rgba(37, 211, 102, 0.55);
          }

          .whatsapp-float svg {
               width: 30px;
               height: 30px;
               fill: #ffffff;
          }


  .privacy-note {
    font-size: 0.7rem;
    text-align: center;
    color: var(--gray-muted);
    margin-top: 20px;
    border-top: 1px solid rgba(200, 168, 107, 0.2);
    padding-top: 16px;
  }

  /* ========== TOAST ========== */
  .toast-message {
    position: fixed;
    bottom: 30px;
    left: 50%;
    transform: translateX(-50%) translateY(20px);
    background: #1e1c16e6;
    backdrop-filter: blur(12px);
    border: 1px solid var(--gold-primary);
    color: #fef2e0;
    padding: 12px 28px;
    border-radius: 60px;
    font-size: 0.85rem;
    font-weight: 500;
    z-index: 9999;
    opacity: 0;
    transition: opacity 0.25s, transform 0.3s;
    pointer-events: none;
    font-family: var(--font-sans);
    box-shadow: 0 8px 20px black;
  }

  .toast-message.show {
    opacity: 1;
    transform: translateX(-50%) translateY(0);
  }

  /* ========== REVEAL ANIMATIONS ========== */
  .reveal {
    opacity: 0; transform: translateY(30px);
    transition: opacity 0.7s cubic-bezier(0.4,0,0.2,1), transform 0.7s cubic-bezier(0.4,0,0.2,1);
  }

  .reveal.visible { opacity: 1; transform: translateY(0); }
  .reveal-delay-1 { transition-delay: 0.1s; }
  .reveal-delay-2 { transition-delay: 0.2s; }
  .reveal-delay-3 { transition-delay: 0.3s; }
  .reveal-delay-4 { transition-delay: 0.4s; }
  .reveal-delay-5 { transition-delay: 0.5s; }

  /* ========== RESPONSIVE ========== */
  @media (max-width: 1024px) {
    .svc-grid { grid-template-columns: repeat(2, 1fr); gap: 20px; }
  }

  @media (max-width: 900px) {
    .about-inner    { grid-template-columns: 1fr; gap: 40px; }
    .steps-track    { flex-direction: column; align-items: center; }
    .steps-track::before { display: none; }
    .step           { flex-direction: row; text-align: left; gap: 20px; width: 100%; margin-bottom: 25px; }
    .step-node      { margin-bottom: 0; flex-shrink: 0; }
    .why-inner      { grid-template-columns: 1fr; gap: 40px; }
  }

  @media (max-width: 768px) {
    .hero           { padding: 110px 5% 40px; }
    .hero-tag       { font-size: 0.55rem; letter-spacing: 0.2em; }
    .hero-tag::before, .hero-tag::after { width: 20px; }
    .svc-grid       { grid-template-columns: 1fr; max-width: 400px; margin: 0 auto; }
    .svc-card       { height: 320px; }
    .about-accent-box { bottom: -52px; right: -8px; padding: 12px 18px; width: 130px; }
    .about-accent-box .num { font-size: 1.6rem; }
  }

  @media (max-width: 580px) {
    .popup-body     { padding: 20px 22px 28px; }
    .form-row-dual  { grid-template-columns: 1fr; gap: 16px; }
    .popup-header   { padding: 18px 22px 12px; }
    .popup-title    { font-size: 1.4rem; }
  }

  @media (max-width: 480px) {
    .hero-btns      { flex-direction: column; align-items: stretch; }
    .btn-primary, .btn-secondary { text-align: center; justify-content: center; }
    .trust-item     { gap: 12px; }
    .why-card       { flex-direction: column; align-items: flex-start; }
    .cta-eyebrow::before, .cta-eyebrow::after { width: 20px; }
    .popup-header   { padding: 14px 20px 10px; }
    .popup-body     { padding: 16px 20px 24px; }
  }
</style>
</head>
<body>

     <%@ include file="header.jsp" %>

  <!-- ========== HERO ========== -->
  <section class="hero">
    <div class="hero-grid"></div>
    <div class="hero-orb hero-orb-1"></div>
    <div class="hero-orb hero-orb-2"></div>
    <div class="hero-content">
      <div class="hero-tag">Surveillance &middot; Check on Check &middot; Retainers &middot; Facilitators</div>
        <h1 class="hero-title">VNext <span class="gold">Legal</span>LLP</h1>
               <p class="hero-subtitle">YOUR TRUST, OUR COMMITMENET,LEGAL PEACE VNEXT</p>
      <div class="hero-divider">
        <div class="hero-divider-line"></div>
        <div class="hero-divider-diamond"></div>
        <div class="hero-divider-line"></div>
      </div>
      <p class="hero-desc">Strategic legal advisory, compliance support, surveillance services, verification solutions,
        and professional retainership — protecting your interests through practical guidance and proactive risk management.</p>
      <div class="hero-btns">
        <a href="./contact" class="btn-primary consult-trigger"><span>Schedule a Consultation</span></a>
        <a href="./service" class="btn-secondary">Explore Services</a>
      </div>
    </div>
  </section>

  <!-- ========== MARQUEE ========== -->
  <div class="marquee-wrap">
    <div class="marquee-track">
      <div class="marquee-item">Surveillance Services</div>
      <div class="marquee-item">Check on Check Verification</div>
      <div class="marquee-item">Legal Retainers</div>
      <div class="marquee-item">Facilitator Services</div>
      <div class="marquee-item">Corporate Investigations</div>
      <div class="marquee-item">Compliance Support</div>
      <div class="marquee-item">Due Diligence</div>
      <div class="marquee-item">Risk Assessment</div>
      <div class="marquee-item">Surveillance Services</div>
      <div class="marquee-item">Check on Check Verification</div>
      <div class="marquee-item">Legal Retainers</div>
      <div class="marquee-item">Facilitator Services</div>
      <div class="marquee-item">Corporate Investigations</div>
      <div class="marquee-item">Compliance Support</div>
      <div class="marquee-item">Due Diligence</div>
      <div class="marquee-item">Risk Assessment</div>
    </div>
  </div>

  <!-- ========== ABOUT ========== -->
  <section class="about" id="about">
    <div class="about-inner">
      <div class="about-visual reveal">
        <div class="about-img-wrap">
          <img src="${baseUrl}/vnextimages/companyfiles/legal2.png" alt="VNext Legal office">
          <div class="about-accent-box">
            <span class="num">30+</span>
            <div class="lbl">Years of Legal<br>Excellence</div>
          </div>
        </div>
      </div>
      <div class="about-text reveal reveal-delay-2">
        <div class="section-label">About VNext Legal LLP</div>
        <h2 class="section-title">A Multidisciplinary Legal <span class="gold">Consultancy</span></h2>
        <div class="gold-line"></div>
        <p class="about-text-body">VNext Legal LLP is dedicated to delivering comprehensive legal solutions to corporates,
          institutions, and individuals. With extensive experience in legal advisory, investigations, compliance
          verification, and legal facilitation, we help our clients navigate complex legal challenges with confidence.</p>
        <div class="trust-list">
          <div class="trust-item">
            <div class="trust-icon">
              <svg viewBox="0 0 24 24"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>
            </div>
            <div class="trust-text">
              <strong>Experienced Legal Professionals</strong>
              <span>Advocates, solicitors and consultants with deep industry expertise</span>
            </div>
          </div>
          <div class="trust-item">
            <div class="trust-icon">
              <svg viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
            </div>
            <div class="trust-text">
              <strong>Confidential &amp; Ethical Practices</strong>
              <span>Highest standards of professional discretion and trust</span>
            </div>
          </div>
          <div class="trust-item">
            <div class="trust-icon">
              <svg viewBox="0 0 24 24">
                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                <circle cx="9" cy="7" r="4"/>
                <path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/>
              </svg>
            </div>
            <div class="trust-text">
              <strong>Client-Centric Approach</strong>
              <span>Personalized solutions tailored to unique objectives</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- ========== SERVICES ========== -->
  <section class="svc-section" id="services">
    <div class="svc-label">Our Services</div>
    <h2 class="svc-title">What We Are Offering<br>to Our <span>Potential Clients</span></h2>
    <div class="svc-divider"></div>
    <p class="svc-subtitle">Four pillars of legal excellence, each designed to protect your interests and empower your decisions.</p>
    <div class="svc-grid">
      <div class="svc-card">
        <img src="${baseUrl}/vnextimages/companyfiles/surveillance.png" alt="Surveillance Services"/>
        <div class="svc-card-body">
          <div class="svc-num">01</div>
          <div class="svc-icon"><svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/><path d="M11 8v6M8 11h6"/></svg></div>
          <div class="svc-name">Surveillance Services</div>
          <p class="svc-desc">Professional investigative services gathering critical information within legal and ethical boundaries.</p>
          <ul class="svc-list">
            <li>Corporate Investigations</li>
            <li>Background Verification</li>
            <li>Fraud Detection</li>
            <!-- <li>Due Diligence Support</li> -->
          </ul>
        </div>
      </div>
      <div class="svc-card">
        <img src="${baseUrl}/vnextimages/companyfiles/verification.png" alt="Check on Check Verification"/>
        <div class="svc-card-body">
          <div class="svc-num">02</div>
          <div class="svc-icon"><svg viewBox="0 0 24 24"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg></div>
          <div class="svc-name">Check on Check Verification</div>
          <p class="svc-desc">Ensuring accuracy, transparency, and accountability through independent verification processes.</p>
          <ul class="svc-list">
            <li>Document Verification</li>
            <li>Compliance Validation</li>
            <li>Information Cross-Checking</li>
           <!--  <li>Operational Audits</li> -->
          </ul>
        </div>
      </div>
      <div class="svc-card">
        <img src="${baseUrl}/vnextimages/companyfiles/retailer.png" alt="Legal Retainers"/>
        <div class="svc-card-body">
          <div class="svc-num">03</div>
          <div class="svc-icon"><svg viewBox="0 0 24 24"><rect x="2" y="3" width="20" height="14" rx="2"/><path d="M8 21h8M12 17v4"/><path d="M7 8h10M7 12h6"/></svg></div>
          <div class="svc-name">Legal Retainers</div>
          <p class="svc-desc">Dedicated legal support through customized retainership programs providing ongoing professional guidance.</p>
          <ul class="svc-list">
            <li>Continuous Legal Support</li>
            <li>Contract Review &amp; Drafting</li>
            <li>Regulatory Compliance</li>
            <!-- <li>Corporate Advisory</li> -->
          </ul>
        </div>
      </div>
      <div class="svc-card">
        <img src="${baseUrl}/vnextimages/companyfiles/facilitor.png" alt="Facilitator Services"/>
        <div class="svc-card-body">
          <div class="svc-num">04</div>
          <div class="svc-icon"><svg viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/></svg></div>
          <div class="svc-name">Facilitator Services</div>
          <p class="svc-desc">Streamlining legal, administrative, and regulatory processes through expert facilitation and support.</p>
          <ul class="svc-list">
            <li>Government Liaison Support</li>
            <li>Regulatory Process Assistance</li>
            <li>Documentation Coordination</li>
         <!--    <li>Business Support Services</li> -->
          </ul>
        </div>
      </div>
    </div>
  </section>

  <!-- ========== APPROACH ========== -->
  <section class="approach" id="approach">
    <div class="approach-inner">
      <div class="approach-head reveal">
        <div class="section-label">Our Approach</div>
        <h2 class="section-title" style="color: white;">Delivering Legal Solutions<br><span class="gold">With Confidence</span></h2>
        <div class="gold-line"></div>
      </div>
      <div class="steps-track">
        <div class="step reveal">
          <div class="step-node"><div class="step-node-num">01</div></div>
          <div>
            <div class="step-title">Consultation</div>
            <p class="step-desc">Understanding your legal requirements and objectives in depth.</p>
          </div>
        </div>
        <div class="step reveal reveal-delay-1">
          <div class="step-node"><div class="step-node-num">02</div></div>
          <div>
            <div class="step-title">Assessment</div>
            <p class="step-desc">Evaluating risks, opportunities, and legal implications thoroughly.</p>
          </div>
        </div>
        <div class="step reveal reveal-delay-2">
          <div class="step-node"><div class="step-node-num">03</div></div>
          <div>
            <div class="step-title">Strategy</div>
            <p class="step-desc">Developing tailored legal solutions and precise action plans.</p>
          </div>
        </div>
        <div class="step reveal reveal-delay-3">
          <div class="step-node"><div class="step-node-num">04</div></div>
          <div>
            <div class="step-title">Execution</div>
            <p class="step-desc">Professional support, representation, and decisive action.</p>
          </div>
        </div>
        <div class="step reveal reveal-delay-4">
          <div class="step-node"><div class="step-node-num">05</div></div>
          <div>
            <div class="step-title">Ongoing Support</div>
            <p class="step-desc">Continuous guidance for sustained, long-term success.</p>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- ========== WHY CHOOSE US ========== -->
  <section class="why" id="why">
    <div class="why-inner">
      <div class="why-left">
        <div class="reveal"><div class="section-label"><span></span>Why Choose Us</div></div>
        <h2 class="section-title reveal reveal-delay-1">Why Our Law Firm Delivers<br><span class="gold">Trusted,</span> Transparent<br>&amp; Result-Driven Solutions</h2>
        <div class="gold-line reveal reveal-delay-1"></div>
        <div class="why-img-wrap reveal reveal-delay-3"><img src="${baseUrl}/vnextimages/companyfiles/aboutimg.png" alt="VNext Legal Team"/></div>
      </div>
      <div class="why-right">
        <div class="why-card reveal reveal-delay-4">
          <div class="why-icon-wrap"><svg viewBox="0 0 24 24"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg></div>
          <div class="why-content">
            <h3>Professional Expertise</h3>
            <p>Experienced advocates, solicitors, and consultants delivering practical legal solutions backed by deep industry knowledge and decades of combined experience.</p>
          </div>
        </div>
        <div class="why-card reveal reveal-delay-4">
          <div class="why-icon-wrap"><svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg></div>
          <div class="why-content">
            <h3>Client-Focused Service</h3>
            <p>Every client receives personalized attention and bespoke solutions tailored precisely to their unique requirements, challenges, and strategic goals.</p>
          </div>
        </div>
        <div class="why-card reveal reveal-delay-5">
          <div class="why-icon-wrap"><svg viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg></div>
          <div class="why-content">
            <h3>Confidentiality &amp; Trust</h3>
            <p>We uphold the highest standards of professional ethics, absolute discretion, and confidentiality across every client engagement and interaction.</p>
          </div>
        </div>
        <div class="why-card reveal reveal-delay-5">
          <div class="why-icon-wrap"><svg viewBox="0 0 24 24"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg></div>
          <div class="why-content">
            <h3>Proven Reliability</h3>
            <p>Clients rely on us for timely advice, strategic guidance, and dependable legal support — consistently delivering outcomes that exceed expectations.</p>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- ========== CTA ========== -->
  <section class="cta-section" id="contact">
    <div class="cta-inner reveal">
      <div class="cta-eyebrow">Get in Touch</div>
      <h2 class="cta-title">Need Professional<br><span style="color: var(--gold);">Legal Assistance?</span></h2>
      <p class="cta-sub">Whether you require surveillance, verification, retainership, or facilitation — VNext Legal LLP is ready to assist. Let us discuss your legal requirements today.</p>
      <div style="display:flex;gap:16px;justify-content:center;flex-wrap:wrap;">
        <a href="./contact" class="btn-primary"><span>Contact Us Now</span></a>
      </div>
    </div>
  </section>




  <!-- WHATSAPP FLOATING BUTTON -->
     <a href="https://wa.me/919818454150" class="whatsapp-float" target="_blank" rel="noopener noreferrer" aria-label="Chat on WhatsApp">
          <svg viewBox="0 0 32 32" xmlns="http://www.w3.org/2000/svg">
               <path d="M16 2C8.268 2 2 8.268 2 16c0 2.49.675 4.816 1.848 6.815L2 30l7.388-1.822A13.94 13.94 0 0 0 16 30c7.732 0 14-6.268 14-14S23.732 2 16 2zm0 25.6a11.56 11.56 0 0 1-5.892-1.608l-.422-.252-4.384 1.082 1.104-4.272-.276-.438A11.52 11.52 0 0 1 4.4 16C4.4 9.59 9.59 4.4 16 4.4S27.6 9.59 27.6 16 22.41 27.6 16 27.6zm6.326-8.662c-.346-.174-2.05-1.012-2.368-1.128-.316-.116-.546-.174-.776.174-.23.346-.892 1.128-1.094 1.36-.2.23-.4.26-.748.086-.346-.174-1.46-.538-2.782-1.716-1.028-.916-1.722-2.048-1.924-2.394-.2-.346-.022-.532.152-.706.156-.154.346-.404.52-.606.172-.2.23-.346.346-.578.116-.23.058-.432-.028-.606-.086-.174-.776-1.872-1.064-2.562-.28-.672-.564-.58-.776-.59l-.66-.012c-.23 0-.606.086-.922.432-.318.346-1.21 1.182-1.21 2.882s1.238 3.344 1.41 3.574c.172.23 2.436 3.718 5.9 5.212.824.356 1.468.568 1.97.726.828.264 1.582.226 2.178.138.664-.1 2.05-.838 2.34-1.648.29-.81.29-1.504.202-1.648-.086-.144-.316-.23-.662-.404z"/>
          </svg>
     </a>

  <!-- ========== CONSULTATION POPUP ========== -->
  <div class="popup-overlay" id="popupOverlay">
    <div class="popup">
      <div class="popup-header">
        <div class="popup-title">Schedule an Appointment</div>
      <button class="popup-close" id="popupClose" aria-label="Close window">
    <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
         xmlns="http://www.w3.org/2000/svg" style="color: var(--gold-dark); font-weight: 900; font-size: 10px;">
        <path d="M18 6L6 18M6 6L18 18"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"/>
    </svg>
</button>
      </div>
      <div class="popup-body">
        <form id="consultationForm" novalidate>
          <div class="form-row-dual">
            <div class="input-wrapper">
              <label for="firstName" class="form-label">First name <span class="required-star"></span></label>
              <input type="text" id="firstName" class="form-input" placeholder="Your First Name" autocomplete="given-name">
              <div class="error-message" id="firstNameError"></div>
            </div>
            <div class="input-wrapper">
              <label for="lastName" class="form-label">Last name <span class="required-star"></span></label>
              <input type="text" id="lastName" class="form-input" placeholder="Your Last Name" autocomplete="family-name">
              <div class="error-message" id="lastNameError"></div>
            </div>
          </div>

          <div class="form-row-dual">
            <div class="input-wrapper">
              <label for="email" class="form-label">Email address <span class="required-star"></span></label>
              <input type="email" id="email" class="form-input" placeholder="Enter you Email" autocomplete="email">
              <div class="error-message" id="emailError"></div>
            </div>
            <div class="input-wrapper">
              <label for="phone" class="form-label">Phone number</label>
              <input type="tel" id="phone" class="form-input" placeholder="Enter you PhoneNo" autocomplete="tel">
              <div class="error-message" id="phoneError"></div>
            </div>
          </div>

          <div class="form-group">
            <label for="message" class="form-label">Your Message</label>
            <textarea id="message" class="form-textarea" placeholder="Tell us about your legal requirements, timeline, or any specific concerns..."></textarea>
            <div class="error-message" id="messageError"></div>
          </div>

          <button type="submit" class="form-submit"><span>&#10022; Submit Consultation Request &#10022;</span></button>

        </form>
      </div>
    </div>
  </div>
  <!-- END POPUP -->

  <!-- ========== TOAST ========== -->
  <div class="toast-message" id="toastMessage"></div>

   <%@ include file="footer.jsp" %>

  <script>
  (function () {
    // ── Scroll reveal ──────────────────────────────────────────
    var reveals  = document.querySelectorAll('.reveal');
    var observer = new IntersectionObserver(function (entries) {
      entries.forEach(function (e) {
        if (e.isIntersecting) {
          e.target.classList.add('visible');
          observer.unobserve(e.target);
        }
      });
    }, { threshold: 0.1 });
    reveals.forEach(function (el) { observer.observe(el); });

    // ── Popup helpers ──────────────────────────────────────────
    var popupOverlay = document.getElementById('popupOverlay');
    var popupClose   = document.getElementById('popupClose');

    function openPopup() {
      popupOverlay.classList.add('open');
      document.body.style.overflow = 'hidden';
    }

    function closePopup() {
      popupOverlay.classList.remove('open');
      document.body.style.overflow = '';
    }

    // Open popup when any consult-trigger is clicked
    document.querySelectorAll('.consult-trigger').forEach(function (el) {
      el.addEventListener('click', function (e) {
        e.preventDefault();
        openPopup();
      });
    });

    // Close via ✕ button
    if (popupClose) {
      popupClose.addEventListener('click', closePopup);
    }

    // Close by clicking the dark backdrop
    popupOverlay.addEventListener('click', function (e) {
      if (e.target === popupOverlay) closePopup();
    });

    // Close with Escape key
    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape') closePopup();
    });

    // ── Toast helper ───────────────────────────────────────────
    function showToast(msg) {
      var toast = document.getElementById('toastMessage');
      if (!toast) return;
      toast.textContent = msg;
      toast.classList.add('show');
      setTimeout(function () { toast.classList.remove('show'); }, 3500);
    }

    // ── Basic form validation & submit ─────────────────────────
    var form = document.getElementById('consultationForm');
    if (form) {
      form.addEventListener('submit', function (e) {
        e.preventDefault();

        var firstName = document.getElementById('firstName');
        var lastName  = document.getElementById('lastName');
        var email     = document.getElementById('email');
        var valid     = true;

        function setError(fieldId, msg) {
          var el = document.getElementById(fieldId + 'Error');
          if (el) el.textContent = msg ? ('⚠ ' + msg) : '';
        }

        setError('firstName', '');
        setError('lastName', '');
        setError('email', '');

        if (!firstName.value.trim()) {
          setError('firstName', 'First name is required.');
          valid = false;
        }

        if (!lastName.value.trim()) {
          setError('lastName', 'Last name is required.');
          valid = false;
        }

        var emailVal = email.value.trim();
        if (!emailVal) {
          setError('email', 'Email address is required.');
          valid = false;
        } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(emailVal)) {
          setError('email', 'Please enter a valid email address.');
          valid = false;
        }

        if (!valid) return;

        // All valid — submit logic goes here
        closePopup();
        form.reset();
        showToast('✓ Your consultation request has been submitted. We\'ll be in touch within 24 hours.');
      });
    }
  })();

  </script>

</body>
</html>

