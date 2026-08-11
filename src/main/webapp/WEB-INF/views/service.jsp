<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover" />
  <title>Services — VNext Legal</title>
  <link
    href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,500;0,600;1,300;1,400;1,500&family=Cinzel:wght@400;500;600&family=Didact+Gothic&display=swap"
    rel="stylesheet" />
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
      --black: #080807;
      --black-soft: #1b1b1a97;
      --black-mid: #161614;
      --white: #FAFAF8;
      --cream: #f4efe6;
      --cream-deep: #e8e0d0;
      --gray-1: #888880;
      --gray-2: #505048;
      --border: rgba(217, 171, 45, 0.36);
      --border-strong: rgba(201, 168, 76, 0.5);
      --border-gold: rgba(201, 168, 76, 0.25);
      --border-gold-strong: rgba(201, 168, 76, 0.6);
      --font-display: 'Cinzel', serif;
      --font-serif: 'Cormorant Garamond', serif;
      --font-body: 'Didact Gothic', sans-serif;
      --nav-h: 72px;
    }

    html {
      scroll-behavior: smooth;
    }

    body {
      background: var(--black);
      color: var(--white);
      font-family: var(--font-body);
      overflow-x: hidden;
    }

    /* ════════════════ NAVBAR ════════════════ */
    nav {
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
      z-index: 200;
      padding: 0 4%;
      display: flex;
      align-items: center;
      justify-content: space-between;
      height: 76px;
      border-bottom: 1px solid var(--border-gold);
      background: rgba(13, 13, 11, 0.88);
      backdrop-filter: blur(24px);
      transition: all 0.4s;
    }

    nav.scrolled {
      height: 62px;
      background: rgba(13, 13, 11, 0.97);
    }

    .logo img {
      height: 84px;
      width: auto;
      object-fit: contain;
      transition: height 0.4s;
    }

    nav.scrolled .logo img {
      height: 60px;
    }

    .nav-links {
      display: flex;
      gap: 2.5rem;
      list-style: none;
    }

    .nav-links a {
      font-family: var(--font-body);
      font-size: 0.82rem;
      letter-spacing: 0.22em;
      text-transform: uppercase;
      color: var(--white);
      text-decoration: none;
      position: relative;
      padding-bottom: 4px;
      transition: color 0.3s;
      font-weight: 700;
    }

    .nav-links a::after {
      content: '';
      position: absolute;
      bottom: 0;
      left: 0;
      width: 0;
      height: 1px;
      background: var(--gold);
      transition: width 0.35s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .nav-links a:hover::after,
    .nav-links a.active::after {
      width: 100%;
    }

    .nav-links a:hover {
      color: var(--gold);
    }

    .nav-cta {
      font-family: var(--font-body);
      font-size: 0.8rem;
      letter-spacing: 0.1em;
      text-transform: uppercase;
      padding: 10px 22px;
      border: 1px solid var(--gold);
      color: var(--gold);
      background: transparent;
      cursor: pointer;
      text-decoration: none;
      transition: all 0.3s;
      white-space: nowrap;
      box-shadow: rgba(192, 149, 20, 0.68) 0px 3px 8px;
      border-radius: 30px;
    }

    .nav-cta:hover {
      background: var(--gold);
      color: var(--black);
      font-weight: 500;
    }

    .hamburger {
      display: none;
      flex-direction: column;
      gap: 5px;
      cursor: pointer;
      padding: 8px;
      background: transparent;
      border: none;
      z-index: 210;
    }

    .hamburger span {
      display: block;
      width: 24px;
      height: 2px;
      background: var(--gold);
      transition: all 0.3s;
    }

    /* ── RESPONSIVE NAV ── */
    @media (max-width: 900px) {
      .nav-links {
        display: none;
      }

      .nav-cta {
        display: none;
      }

      .hamburger {
        display: flex;
      }
    }

    /* ════════════════ SIDEBAR ════════════════ */
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

    /* ════════════════ POPUP ════════════════ */
    .popup-overlay {
      position: fixed;
      inset: 0;
      z-index: 999;
      background: rgba(8, 8, 6, 0.88);
      backdrop-filter: blur(10px);
      display: flex;
      align-items: center;
      justify-content: center;
      opacity: 0;
      pointer-events: none;
      transition: opacity 0.4s;
      padding: 20px;
    }

    .popup-overlay.open {
      opacity: 1;
      pointer-events: all;
    }

    .popup {
      background: var(--black-mid);
      border: 1px solid var(--border-gold);
      max-width: 520px;
      width: 100%;
      border-radius: 20px;
    }

    .popup-header {
      padding: 16px 28px 12px;
      border-bottom: 1px solid var(--border-gold);
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .popup-title {
      font-family: var(--font-display);
      font-size: 1.4rem;
      letter-spacing: 0.06em;
      color: var(--white);
    }

    .popup-close {
      width: 34px;
      height: 34px;
      border: 1px solid var(--border-gold);
      background: transparent;
      cursor: pointer;
      color: var(--gray-1);
      border-radius: 50%;
    }

    .popup-body {
      padding: 20px 28px 28px;
    }

    .form-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 14px;
      margin-bottom: 14px;
    }

    .form-input,
    .form-textarea {
      background: rgba(250, 250, 248, 0.04);
      border: 1px solid var(--border-gold);
      color: var(--white);
      padding: 12px 14px;
      width: 100%;
      border-radius: 17px;
      font-size: 0.85rem;
    }

    .form-textarea {
      min-height: 90px;
      resize: vertical;
    }

    .form-submit {
      width: 100%;
      padding: 14px;
      background: var(--gold);
      border: none;
      cursor: pointer;
      font-family: var(--font-body);
      font-size: 0.7rem;
      letter-spacing: 0.25em;
      text-transform: uppercase;
      border-radius: 17px;
      transition: 0.3s;
      margin-top: 10px;
    }

    .form-submit:hover {
      background: var(--gold-light);
    }

    @media (max-width: 600px) {
      .form-row {
        grid-template-columns: 1fr;
      }
    }

    /* ════════════════ HERO ════════════════ */
    #hero {
      width: 100%;
      min-height: 80vh;
      padding-top: var(--nav-h);
      display: grid;
      grid-template-columns: 1fr 1fr;
      position: relative;
      overflow: hidden;
    }

    .hero-left {
      display: flex;
      flex-direction: column;
      justify-content: center;
      padding: 80px 60px 80px 5%;
      background: var(--black-soft);
      border-right: 1px solid var(--border);
      position: relative;
    }

    .hero-left::after {
      content: '';
      position: absolute;
      top: 8%;
      bottom: 8%;
      right: 0;
      width: 1px;
      background: linear-gradient(180deg, transparent, var(--gold), transparent);
    }

    .ghost-s {
      position: absolute;
      right: -40px;
      bottom: -80px;
      font-family: var(--font-display);
      font-size: 30vw;
      font-weight: 600;
      color: rgba(201, 168, 76, 0.025);
      line-height: 1;
      pointer-events: none;
      user-select: none;
    }

    .h-eyebrow {
      display: flex;
      align-items: center;
      gap: 12px;
      font-family: var(--font-body);
      font-size: 0.58rem;
      letter-spacing: 0.45em;
      text-transform: uppercase;
      color: var(--gold);
      margin-bottom: 1.2rem;
      opacity: 0;
      animation: up 0.7s 0.3s forwards;
    }

    .h-eyebrow span {
      width: 32px;
      height: 1px;
      background: var(--gold);
      display: block;
    }

    .h-h1 {
      font-family: var(--font-display);
      font-size: clamp(2.6rem, 4.2vw, 5rem);
      font-weight: 600;
      letter-spacing: 0.04em;
      line-height: 1;
      color: var(--white);
      opacity: 0;
      animation: up 0.8s 0.5s forwards;
    }

    .h-h1 em {
      color: var(--gold);
      font-style: normal;
      display: block;
    }

    .h-divider {
      display: flex;
      align-items: center;
      gap: 12px;
      margin: 1.8rem 0;
      opacity: 0;
      animation: up 0.7s 0.7s forwards;
    }

    .h-divider-line {
      width: 48px;
      height: 1px;
      background: var(--border-strong);
    }

    .h-divider-diamond {
      width: 7px;
      height: 7px;
      border: 1px solid var(--gold);
      transform: rotate(45deg);
      animation: spin 6s linear infinite;
    }

    .h-desc {
      font-family: var(--font-serif);
      font-size: clamp(1rem, 1.4vw, 1.18rem);
      font-style: italic;
      line-height: 2;
      color: rgba(250, 250, 248, 0.6);
      max-width: 460px;
      opacity: 0;
      animation: up 0.8s 0.9s forwards;
    }

    .h-tagline {
      margin-top: 2rem;
      font-family: var(--font-body);
      font-size: 0.62rem;
      letter-spacing: 0.18em;
      text-transform: uppercase;
      color: var(--gold);
      border-left: 2px solid var(--gold);
      padding-left: 14px;
      opacity: 0;
      animation: up 0.8s 1.1s forwards;
    }

    .hero-right {
      position: relative;
      overflow: hidden;
      background: var(--black-mid);
    }

    .hero-bg {
      position: absolute;
      inset: 0;
      background: url('./images/service.png') center/cover;
      transform: scale(1.06);
    }

    .hero-glow {
      position: absolute;
      inset: 0;
      background: radial-gradient(ellipse 70% 60% at 50% 40%, rgba(201, 168, 76, 0.1) 0%, transparent 70%);
    }

    .vc {
      position: absolute;
      width: 36px;
      height: 36px;
    }

    .vc-tl {
      top: 28px;
      left: 28px;
      border-top: 1px solid rgba(201, 168, 76, 0.6);
      border-left: 1px solid rgba(201, 168, 76, 0.6);
    }

    .vc-tr {
      top: 28px;
      right: 28px;
      border-top: 1px solid rgba(201, 168, 76, 0.6);
      border-right: 1px solid rgba(201, 168, 76, 0.6);
    }

    .vc-bl {
      bottom: 28px;
      left: 28px;
      border-bottom: 1px solid rgba(201, 168, 76, 0.6);
      border-left: 1px solid rgba(201, 168, 76, 0.6);
    }

    .vc-br {
      bottom: 28px;
      right: 28px;
      border-bottom: 1px solid rgba(201, 168, 76, 0.6);
      border-right: 1px solid rgba(201, 168, 76, 0.6);
    }

    @keyframes spin {
      to {
        transform: rotate(360deg);
      }
    }

    @keyframes up {
      from {
        opacity: 0;
        transform: translateY(28px);
      }

      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    @media(max-width:900px) {
      #hero {
        grid-template-columns: 1fr;
      }

      .hero-left {
        padding: 60px 5%;
        min-height: 65vh;
      }

      .hero-right {
        height: 40vh;
      }

      .ghost-s {
        display: none;
      }
    }

    /* ── SECTION HEADER ── */
    .sec-header {
      text-align: center;
      padding: 21px 5% 18px;
      position: relative;
    }

    .sec-eyebrow {
      display: inline-flex;
      align-items: center;
      gap: 14px;
      font-family: var(--font-body);
      font-size: 0.58rem;
      letter-spacing: 0.5em;
      text-transform: uppercase;
      color: var(--gold);
      margin-bottom: 0.6rem;
    }

    .sec-eyebrow::before,
    .sec-eyebrow::after {
      content: '';
      width: 32px;
      height: 1px;
      background: var(--gold);
      display: block;
    }

    .sec-h2 {
      font-family: var(--font-display);
      font-size: clamp(2.4rem, 4.5vw, 4.8rem);
      font-weight: 600;
      letter-spacing: 0.04em;
      color: var(--white);
      line-height: 1;
    }

    .sec-h2 em {
      color: var(--gold);
      font-style: italic;
    }

    .sec-rule {
      width: 48px;
      height: 1px;
      background: var(--gold);
      margin: 0.4rem auto;
    }

    .sec-sub {
      font-family: var(--font-serif);
      font-size: clamp(1rem, 1.5vw, 1.18rem);
      font-style: italic;
      color: rgba(250, 250, 248, 0.5);
      max-width: 560px;
      margin: 0 auto;
      line-height: 2;
    }

    /* ── PRACTICE AREAS ── */
    #practice {
      background: var(--black-soft);
      border-top: 1px solid var(--border);
      padding-bottom: 46px;
    }

    .practice-grid {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 1px;
      background: var(--border);
      margin: 0 5%;
      border: 1px solid var(--border);
    }

    .p-card {
      background: var(--black-soft);
      padding: 36px 30px;
      position: relative;
      overflow: hidden;
      transition: background 0.35s;
      cursor: default;
    }

    .p-card::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 2px;
      background: var(--gold);
      transform: scaleX(0);
      transform-origin: left;
      transition: transform 0.4s ease;
    }

    .p-card:hover::before {
      transform: scaleX(1);
    }

    .p-card-ghost {
      position: absolute;
      right: -12px;
      bottom: -20px;
      font-family: var(--font-display);
      font-size: 7rem;
      font-weight: 600;
      color: rgba(201, 168, 76, 0.03);
      line-height: 1;
      pointer-events: none;
      user-select: none;
      transition: color 0.4s;
    }

    .p-card:hover .p-card-ghost {
      color: rgba(201, 168, 76, 0.06);
    }

    .p-icon {
      width: 60px;
      height: 60px;
      border: 1px solid var(--border);
      display: flex;
      align-items: center;
      justify-content: center;
      background: rgba(201, 168, 76, 0.06);
      margin-bottom: 20px;
      transition: all 0.3s;
    }

    .p-card:hover .p-icon {
      border-color: var(--gold);
      background: rgba(201, 168, 76, 0.12);
    }

    .p-icon svg {
      width: 30px;
      height: 30px;
      stroke: var(--gold);
      fill: none;
      stroke-width: 1.4;
      stroke-linecap: round;
      stroke-linejoin: round;
    }

    .p-title {
      font-family: var(--font-display);
      font-size: 0.89rem;
      letter-spacing: 0.14em;
      text-transform: uppercase;
      color: var(--white);
      margin-bottom: 10px;
      transition: color 0.3s;
      font-weight: 900;
    }

    .p-card:hover .p-title {
      color: var(--gold);
    }

    .p-desc {
      /* font-family: var(--font-serif); */
      font-size: 0.98rem;
      color: rgba(250, 250, 248, 0.843);
      line-height: 1.75;
      transition: color 0.3s;
    }

    .p-card:hover .p-desc {
      color: rgba(250, 250, 248, 0.7);
    }

    @media(max-width:1100px) {
      .practice-grid {
        grid-template-columns: repeat(2, 1fr);
      }
    }

    @media(max-width:600px) {
      .practice-grid {
        grid-template-columns: 1fr;
        margin: 0 4%;
      }
    }

    /* ── SPECIAL SERVICES ── */
   /* ── SPECIAL SERVICES ── */
#special {
  background: var(--cream);
  border-top: 1px solid var(--border);
  padding: 0px 0px 24px;
}

#special .sec-h2 { color: #1a1208; }
#special .sec-sub { color: #5a4e38; }
#special .sec-eyebrow { color: var(--gold-dark); }
#special .sec-eyebrow::before,
#special .sec-eyebrow::after { background: var(--gold-dark); }
#special .sec-rule { background: var(--gold-dark); }

.special-wrap {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 0;
  margin: 0 5%;
  border: 1px solid rgba(139, 105, 20, 0.2);
}

.spec-col {
  background: var(--cream-deep);
  border-right: 1px solid rgba(139, 105, 20, 0.2);
}

.spec-col:last-child { border-right: none; }

.spec-col.dark {
  background: #1a1208;
}

.spec-col-head {
  padding: 22px 30px;
  display: flex;
  align-items: center;
  gap: 16px;
  border-bottom: 2px solid var(--gold-dark);
}

.spec-col-num {
  font-family: var(--font-display);
  font-size: 1.4rem;
  color: var(--gold-dark);
  line-height: 1;
  flex-shrink: 0;
}

.spec-col.dark .spec-col-num { color: var(--gold); }

.spec-col-head-title {
  font-family: var(--font-display);
  font-size: 0.7rem;
  letter-spacing: 0.22em;
  text-transform: uppercase;
  color: #1a1208;
}

.spec-col.dark .spec-col-head-title { color: var(--gold); }

.spec-list { display: flex; flex-direction: column; }

.spec-item {
  display: flex;
  align-items: flex-start;
  gap: 20px;
  padding: 26px 30px;
  border-bottom: 1px solid rgba(139, 105, 20, 0.15);
  position: relative;
  transition: padding-left 0.35s, background 0.3s;
}

.spec-col.dark .spec-item {
  border-bottom: 1px solid rgba(201, 168, 76, 0.15);
}

.spec-item:last-child { border-bottom: none; }

.spec-item:hover {
  background: rgba(201, 168, 76, 0.08);
  padding-left: 38px;
}

.spec-num {
  font-family: var(--font-display);
  font-size: 2rem;
  font-weight: 700;
  color: rgba(139, 105, 20, 0.35);
  line-height: 1;
  flex-shrink: 0;
  width: 48px;
  transition: color 0.3s;
}

.spec-col.dark .spec-num { color: rgba(201, 168, 76, 0.3); }

.spec-item:hover .spec-num { color: var(--gold-dark); }
.spec-col.dark .spec-item:hover .spec-num { color: var(--gold); }

.spec-title {
  font-size: 0.99rem;
  text-transform: uppercase;
  font-weight: 800;
  color: #1a1208;
  margin-bottom: 6px;
  transition: color 0.3s;
}

.spec-col.dark .spec-title { color: var(--cream); }

.spec-item:hover .spec-title { color: var(--gold-dark); }
.spec-col.dark .spec-item:hover .spec-title { color: var(--gold); }

.spec-desc {
  font-family: var(--font-serif);
  font-size: 0.95rem;
  color: #363026;
  line-height: 1.65;
}

.spec-col.dark .spec-desc { color: #cfc6b3; }

@media(max-width:760px) {
  .special-wrap { grid-template-columns: 1fr; }
  .spec-col { border-right: none; border-bottom: 2px solid rgba(139, 105, 20, 0.25); }
}
    /* ── CYBER LAW ── */
    #cyber {
      background: var(--black);
      border-top: 1px solid var(--border);
      padding: 0px 0px 26px;
    }

    .cyber-inner {
      margin: 0 5%;
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 1px;
      background: var(--border);
      border: 1px solid var(--border);
    }

    .cyber-art {
      background: var(--black-mid);
      position: relative;
      overflow: hidden;
      min-height: 380px;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .cyber-art-bg {
      position: absolute;
      inset: 0;
      background: url('./images/cyber.png') center/cover;
     filter: brightness(0.90) saturate(0.9);
    }

    .cyber-art-glow {
      position: absolute;
      inset: 0;
      background: radial-gradient(ellipse 70% 60% at 50% 50%, rgba(201, 168, 76, 0.13) 0%, transparent 70%);
    }

    .cyber-art-content {
      position: relative;
      z-index: 1;
      text-align: center;
      padding: 40px;
    }

    .cyber-ring {
      width: 100px;
      height: 100px;
      border-radius: 50%;
      border: 1px solid rgba(201, 168, 76, 0.35);
      display: flex;
      align-items: center;
      justify-content: center;
      margin: 0 auto 20px;
      position: relative;
    }

    .cyber-ring::before {
      content: '';
      position: absolute;
      inset: 10px;
      border-radius: 50%;
      border: 1px dashed rgba(201, 168, 76, 0.2);
      animation: spin 8s linear infinite;
    }

    .cyber-ring svg {
      width: 40px;
      height: 40px;
      stroke: var(--gold);
      fill: none;
      stroke-width: 1.2;
      opacity: 0.7;
    }

    .cyber-art-label {
      font-family: var(--font-display);
      font-size: 1.4rem;
      letter-spacing: 0.1em;
      color: var(--gold);
      display: block;
      margin-bottom: 6px;
    }

    .cyber-art-sub {
      font-family: var(--font-body);
      font-size: 0.54rem;
      letter-spacing: 0.35em;
      text-transform: uppercase;
      color: rgba(201, 168, 76, 0.45);
    }

    .cyber-content {
      background: #45585d8e;;
      padding: 40px 44px;
      display: flex;
      flex-direction: column;
      justify-content: center;
    }

    .cyber-label {
      display: flex;
      align-items: center;
      gap: 12px;
      font-family: var(--font-body);
      font-size: 0.59rem;
      letter-spacing: 0.48em;
      text-transform: uppercase;
      color: var(--gold);
      margin-bottom: 1.8rem;
    }

    .cyber-label::before {
      content: '';
      width: 24px;
      height: 1px;
      background: var(--gold);
    }

    .cyber-h3 {
      font-family: var(--font-display);
      font-size: clamp(1.6rem, 2.8vw, 2.6rem);
      font-weight: 600;
      color: white;
      line-height: 1.1;
      letter-spacing: 0.04em;
      margin-bottom: 1.4rem;
    }

    .cyber-h3 span {
      color: var(--gold);
      display: block;
    }

    .cyber-desc {
      /* font-family: var(--font-serif); */
      font-size: 0.99rem;
      color: rgba(250, 250, 248, 0.9);
      line-height: 1.85;
      font-style: italic;
      margin-bottom: 1.8rem;
      border-left: 2px solid rgba(201, 168, 76, 0.35);
      padding-left: 16px;
    }

    .cyber-items {
      display: flex;
      flex-direction: column;
      gap: 0;
    }

    .cyber-item {
      display: flex;
      align-items: center;
      gap: 14px;
      padding: 10px 0;
      border-bottom: 1px solid var(--border);
      transition: all 0.3s;
    }

    .cyber-item:first-child {
      border-top: 1px solid var(--border);
    }

    .cyber-item:hover {
      padding-left: 6px;
    }

    .cyber-dot {
      width: 4px;
      height: 4px;
      border-radius: 50%;
      background: var(--gold);
      flex-shrink: 0;
    }

    .cyber-item-text {
      font-family: var(--font-body);
      font-size: 0.78rem;
      letter-spacing: 0.08em;
      text-transform: uppercase;
      color: rgba(250, 250, 248, 0.875);
      transition: color 0.3s;
    }

    .cyber-item:hover .cyber-item-text {
      color: var(--gold);
    }

    @media(max-width:800px) {
      .cyber-inner {
        grid-template-columns: 1fr;
      }

      .cyber-art {
        min-height: 260px;
      }

      .cyber-content {
        padding: 36px 5%;
      }
    }

    /* ── CTA STRIP ── */
    #cta-strip {
      background: var(--black-mid);
      border-top: 1px solid var(--border);
      padding: 70px 5%;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 32px;
      flex-wrap: wrap;
      position: relative;

    }

    #cta-strip::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 2px;
      background: linear-gradient(90deg, transparent, var(--gold), var(--gold-pale), var(--gold), transparent);
    }

    .cta-text {
      max-width: 600px;
    }

    .cta-tag {
      font-family: var(--font-body);
      font-size: 0.58rem;
      letter-spacing: 0.46em;
      text-transform: uppercase;
      color: var(--gold);
      display: flex;
      align-items: center;
      gap: 12px;
      margin-bottom: 1.2rem;

    }

    .cta-tag::before {
      content: '';
      width: 28px;
      height: 1px;
      background: var(--gold);
    }

    .cta-h {
      font-family: var(--font-display);
      font-size: clamp(1.8rem, 3vw, 3rem);
      font-weight: 600;
      color: var(--white);
      line-height: 1.1;
    }

    .cta-h em {
      color: var(--gold);
      font-style: italic;
    }

    .cta-sub {
      font-family: var(--font-serif);
      font-size: 1rem;
      font-style: italic;
      color: var(--gray-1);
      margin-top: 0.8rem;
      line-height: 1.7;
    }

    .cta-btn {
      font-family: var(--font-body);
      font-size: 0.7rem;
      letter-spacing: 0.2em;
      text-transform: uppercase;
      font-weight: 500;
      padding: 16px 40px;
      border: 1px solid var(--gold);
      color: var(--gold);
      background: transparent;
      cursor: pointer;
      text-decoration: none;
      border-radius: 40px;
      transition: all 0.35s;
      box-shadow: 0 0 20px rgba(201, 168, 76, 0.12);
      white-space: nowrap;
    }

    .cta-btn:hover {
      background: var(--gold);
      color: var(--black);
      box-shadow: 0 0 36px rgba(201, 168, 76, 0.35);
    }

    /* ════════════════ FOOTER ════════════════ */
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
    }

    .footer-brand-sub {
      font-size: 0.55rem;
      letter-spacing: 0.25em;
      text-transform: uppercase;
      color: var(--gray-2);
      display: block;
      margin: 6px 0;
    }

    .footer-brand-desc {
      font-family: var(--font-serif);
      font-size: 0.85rem;
      line-height: 1.7;
      color: var(--gray-1);
    }

    .footer-col-title {
      font-family: var(--font-body);
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
      font-family: var(--font-serif);
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

    @media(max-width:900px) {
      .footer-inner {
        grid-template-columns: 1fr;
        gap: 30px;
      }
    }

    /* ── REVEAL ── */
    .reveal {
      opacity: 0;
      transform: translateY(36px);
      transition: opacity 0.8s cubic-bezier(0.4, 0, 0.2, 1), transform 0.8s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .reveal.in {
      opacity: 1;
      transform: translateY(0);
    }

    .d1 {
      transition-delay: 0.1s;
    }

    .d2 {
      transition-delay: 0.22s;
    }

    .d3 {
      transition-delay: 0.34s;
    }

    .d4 {
      transition-delay: 0.46s;
    }

    .d5 {
      transition-delay: 0.58s;
    }

    .d6 {
      transition-delay: 0.7s;
    }
  </style>
</head>

<body>

   <%@ include file="header.jsp" %>

  <!-- HERO -->
  <section id="hero">
    <div class="hero-left">
      <div class="ghost-s">S</div>
      <div class="h-eyebrow"><span></span>Areas of Practice</div>
      <h1 class="h-h1">Our<em>Services</em></h1>
      <div class="h-divider">
        <div class="h-divider-line"></div>
        <div class="h-divider-diamond"></div>
        <div class="h-divider-line"></div>
      </div>
      <p class="h-desc">V-Next Legal LLP offers comprehensive legal services across diverse practice areas — combining
        three decades of expertise with a relentless commitment to client success.</p>
      <div class="h-tagline">Integrity · Expertise · Commitment</div>
    </div>
    <div class="hero-right">
      <div class="hero-bg"></div>
      <div class="hero-glow"></div>
      <div class="vc vc-tl"></div>
      <div class="vc vc-tr"></div>
      <div class="vc vc-bl"></div>
      <div class="vc vc-br"></div>
    </div>
  </section>

  <!-- PRACTICE AREAS -->
  <section id="practice">
    <div class="sec-header reveal">
      <div class="sec-eyebrow">Our Expertise</div>
      <h2 class="sec-h2">Areas of <em>Practice</em></h2>
      <div class="sec-rule"></div>
      <p class="sec-sub">Comprehensive legal coverage across civil, criminal, corporate, and specialized domains — for
        businesses and individuals across India.</p>
    </div>
    <div class="practice-grid">
      <div class="p-card reveal d1">
        <div class="p-card-ghost">SC</div>
        <div class="p-icon"><svg viewBox="0 0 24 24">
            <path d="M3 21h18M6 21V7M18 21V7M4 7h16M12 3L4 7M12 3l8 4" />
            <rect x="9" y="12" width="6" height="9" rx="1" />
          </svg></div>
        <div class="p-title">Supreme Court of India &amp; High Courts</div>
        <div class="p-desc">Constitutional matters, Writ Petitions, Appeals, Special Leave Petitions, Advisory
          Jurisdiction and more.</div>
      </div>
      <div class="p-card reveal d2">
        <div class="p-card-ghost">AR</div>
        <div class="p-icon"><svg viewBox="0 0 24 24">
            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
            <circle cx="9" cy="7" r="4" />
            <path d="M23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75" />
          </svg></div>
        <div class="p-title">Arbitration</div>
        <div class="p-desc">Domestic &amp; International Arbitration, Arbitration Proceedings, Enforcement of Awards,
          Conciliation and Mediation.</div>
      </div>
      <div class="p-card reveal d3">
        <div class="p-card-ghost">IP</div>
        <div class="p-icon"><svg viewBox="0 0 24 24">
            <circle cx="12" cy="12" r="10" />
            <path d="M12 8v4l3 3" />
            <path d="M9.5 9.5a5 5 0 1 1 5 8.66" />
          </svg></div>
        <div class="p-title">Intellectual Property Rights</div>
        <div class="p-desc">Trademarks, Copyrights, Patents, Designs, IP Due Diligence, Licensing and more.</div>
      </div>
      <div class="p-card reveal d1">
        <div class="p-card-ghost">DT</div>
        <div class="p-icon"><svg viewBox="0 0 24 24">
            <rect x="2" y="5" width="20" height="14" rx="2" />
            <path d="M2 10h20" />
            <path d="M6 15h2M12 15h4" />
          </svg></div>
        <div class="p-title">Direct Taxes</div>
        <div class="p-desc">Tax Advisory, Assessments, Appeals, Re-assessments, Tax Planning, Start-up Advisory and
          more.</div>
      </div>
      <div class="p-card reveal d2">
        <div class="p-card-ghost">IT</div>
        <div class="p-icon"><svg viewBox="0 0 24 24">
            <path d="M12 2L2 7l10 5 10-5-10-5z" />
            <path d="M2 17l10 5 10-5" />
            <path d="M2 12l10 5 10-5" />
          </svg></div>
        <div class="p-title">Indirect Taxes</div>
        <div class="p-desc">GST Advisory, Appeals, Customs, Excise, Service Tax, Foreign Trade Policy matters and more.
        </div>
      </div>
      <div class="p-card reveal d3">
        <div class="p-card-ghost">CR</div>
        <div class="p-icon"><svg viewBox="0 0 24 24">
            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
          </svg></div>
        <div class="p-title">Criminal Laws</div>
        <div class="p-desc">White Collar Crimes, Bail, Quashing Proceedings, Criminal Appeals and Litigation.</div>
      </div>
      <div class="p-card reveal d1">
        <div class="p-card-ghost">LL</div>
        <div class="p-icon"><svg viewBox="0 0 24 24">
            <rect x="2" y="7" width="20" height="14" rx="2" />
            <path d="M16 7V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v2" />
            <line x1="12" y1="12" x2="12" y2="16" />
            <line x1="10" y1="14" x2="14" y2="14" />
          </svg></div>
        <div class="p-title">Labour Laws</div>
        <div class="p-desc">Industrial Disputes, Contracts, Compliances, Employment Laws Advisory, Factories Act and
          more.</div>
      </div>
      <div class="p-card reveal d2">
        <div class="p-card-ghost">CO</div>
        <div class="p-icon">  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
       stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
    <path d="M4 22V4H14V22" />
    <path d="M14 10H20V22" />
    <path d="M8 8H10" />
    <path d="M8 12H10" />
    <path d="M8 16H10" />
    <path d="M17 14H18" />
    <path d="M17 18H18" />
  </svg></div>
        <div class="p-title">Corporate Laws</div>
        <div class="p-desc">Incorporation, Corporate Advisory, M&amp;A, Due Diligence, Joint Ventures, Compliance and
          more.</div>
      </div>
      <div class="p-card reveal d3">
        <div class="p-card-ghost">RE</div>
        <div class="p-icon"><svg viewBox="0 0 24 24">
    <path d="M3 10L12 3L21 10V20A2 2 0 0 1 19 22H5A2 2 0 0 1 3 20V10ZM10 22V14H14V22"/>
  </svg></div>
        <div class="p-title">Land &amp; Real Estate</div>
        <div class="p-desc">Title Verification, Leasing, Development Agreements, RERA Advisory, Disputes and more.</div>
      </div>
    </div>
  </section>

  <!-- SPECIAL SERVICES -->
<section id="special">
  <div class="sec-header reveal">
    <div class="sec-eyebrow">Specialised Domains</div>
    <h2 class="sec-h2">Special <em>Services</em></h2>
    <div class="sec-rule"></div>
    <p class="sec-sub">Beyond conventional practice — specialized legal representation for regulatory, insolvency, and infrastructure matters.</p>
  </div>
  <div class="special-wrap reveal d2">
    <div class="spec-col">
      <div class="spec-col-head">
        <span class="spec-col-num">I</span>
        <span class="spec-col-head-title">Special Services</span>
      </div>
      <div class="spec-list">
        <div class="spec-item">
          <div class="spec-num">01</div>
          <div class="spec-body">
            <div class="spec-title">NCLT — National Company Law Tribunal</div>
            <div class="spec-desc">Representation before the National Company Law Tribunal for corporate disputes and proceedings.</div>
          </div>
        </div>
        <div class="spec-item">
          <div class="spec-num">02</div>
          <div class="spec-body">
            <div class="spec-title">PMLA — Prevention of Money Laundering Act</div>
            <div class="spec-desc">Advisory and representation in money laundering proceedings, attachment, and trial matters.</div>
          </div>
        </div>
        <div class="spec-item">
          <div class="spec-num">03</div>
          <div class="spec-body">
            <div class="spec-title">ED — Enforcement Directorate</div>
            <div class="spec-desc">Defense and advisory in matters before the Enforcement Directorate under FEMA and PMLA.</div>
          </div>
        </div>
        <div class="spec-item">
          <div class="spec-num">04</div>
          <div class="spec-body">
            <div class="spec-title">IBC — Insolvency and Bankruptcy Code</div>
            <div class="spec-desc">Corporate insolvency resolution, liquidation, personal insolvency, and related proceedings under IBC.</div>
          </div>
        </div>
      </div>
    </div>

    <div class="spec-col dark">
      <div class="spec-col-head">
        <span class="spec-col-num">II</span>
        <span class="spec-col-head-title">Electricity Matters</span>
      </div>
      <div class="spec-list">
        <div class="spec-item">
          <div class="spec-num">01</div>
          <div class="spec-body">
            <div class="spec-title">Consumer Disputes</div>
            <div class="spec-desc">Representation before Consumer Forums and Commissions for electricity-related grievances.</div>
          </div>
        </div>
        <div class="spec-item">
          <div class="spec-num">02</div>
          <div class="spec-body">
            <div class="spec-title">Supply &amp; Billing Disputes</div>
            <div class="spec-desc">Tariff, Billing, Metering and Demand Issues — expert resolution across regulatory forums.</div>
          </div>
        </div>
        <div class="spec-item">
          <div class="spec-num">03</div>
          <div class="spec-body">
            <div class="spec-title">Connection &amp; Disconnection Issues</div>
            <div class="spec-desc">New Connections, Disconnections, Reconnections and Related Matters handled efficiently.</div>
          </div>
        </div>
        <div class="spec-item">
          <div class="spec-num">04</div>
          <div class="spec-body">
            <div class="spec-title">Regulatory &amp; Compliance Matters</div>
            <div class="spec-desc">Advisory on Electricity Laws, Regulations, Policies and Compliance across state and central bodies.</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

  <!-- CYBER LAW -->
  <section id="cyber">
    <div class="sec-header reveal">
      <div class="sec-eyebrow">Digital Legal Practice</div>
      <h2 class="sec-h2">Cyber <em>Law</em></h2>
      <div class="sec-rule"></div>
      <p class="sec-sub">Cutting-edge representation at the intersection of law and technology — protecting clients in
        the digital domain.</p>
    </div>
    <div class="cyber-inner reveal d2">
      <div class="cyber-art">
        <div class="cyber-art-bg"></div>
        <div class="cyber-art-glow"></div>
        <div class="vc vc-tl"></div>
        <div class="vc vc-tr"></div>
        <div class="vc vc-bl"></div>
        <div class="vc vc-br"></div>
        <div class="cyber-art-content">
          <div class="cyber-ring"><svg viewBox="0 0 24 24">
              <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
              <path d="M9 12l2 2 4-4" />
            </svg></div><span class="cyber-art-label">Cyber Law</span><span class="cyber-art-sub">IT Act · Matters &amp;
            Advisory</span>
        </div>
      </div>
      <div class="cyber-content">
        <div class="cyber-label">IT Act — Matters &amp; Advisory</div>
        <h3 class="cyber-h3">Digital Defence<span>&amp; Cyber Rights</span></h3>
        <p class="cyber-desc">Specialized advisory and litigation in matters arising under the Information Technology
          Act and allied laws — from cyber crimes to digital evidence.</p>
        <div class="cyber-items">
          <div class="cyber-item">
            <div class="cyber-dot"></div><span class="cyber-item-text">Cyber Crime Complaints</span>
          </div>
          <div class="cyber-item">
            <div class="cyber-dot"></div><span class="cyber-item-text">Data Protection &amp; Privacy</span>
          </div>
          <div class="cyber-item">
            <div class="cyber-dot"></div><span class="cyber-item-text">IT Act — Civil &amp; Criminal Proceedings</span>
          </div>
          <div class="cyber-item">
            <div class="cyber-dot"></div><span class="cyber-item-text">Intermediary Liability</span>
          </div>
          <div class="cyber-item">
            <div class="cyber-dot"></div><span class="cyber-item-text">E-Commerce &amp; Online Disputes</span>
          </div>
          <div class="cyber-item">
            <div class="cyber-dot"></div><span class="cyber-item-text">Digital Evidence &amp; Forensics</span>
          </div>
          <div class="cyber-item">
            <div class="cyber-dot"></div><span class="cyber-item-text">Social Media Offences (Defamation, Harassment,
              Impersonation etc.)</span>
          </div>
          <div class="cyber-item">
            <div class="cyber-dot"></div><span class="cyber-item-text">Representation before Police, Cyber Cells &amp;
              Courts</span>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- CTA STRIP -->
  <section id="cta-strip">
    <div class="cta-text">
      <div class="cta-tag">Consultation</div>
      <h2 class="cta-h">Need Expert <em>Legal Guidance?</em></h2>
      <p class="cta-sub">Get in touch with our panel of experienced advocates and legal consultants today.</p>
    </div>
    <a href="contact" class="cta-btn consult-trigger">Schedule Consultation</a>
  </section>


  <%@ include file="footer.jsp" %>


 <script>
    (function () {
      // --------------------------------------------------------------
      // 1. Navbar scroll effect (targets the navbar from header.jsp)
      // --------------------------------------------------------------
      const nav = document.getElementById('navbar');
      if (nav) {
        window.addEventListener('scroll', () => {
          nav.classList.toggle('scrolled', window.scrollY > 60);
        });
      }

      // --------------------------------------------------------------
      // 2. Sidebar functionality (with safety checks)
      // --------------------------------------------------------------
      const hamburgerBtn = document.getElementById('hamburgerBtn');
      const sidebar = document.getElementById('sidebarNav');
      const overlay = document.getElementById('sidebarOverlay');
      const closeSidebarBtn = document.getElementById('closeSidebarBtn');

      function openSidebar() {
        if (!sidebar || !overlay) return;
        sidebar.classList.add('open');
        overlay.classList.add('active');
        document.body.style.overflow = 'hidden';
      }

      function closeSidebar() {
        if (!sidebar || !overlay) return;
        sidebar.classList.remove('open');
        overlay.classList.remove('active');
        document.body.style.overflow = '';
      }

      if (hamburgerBtn) hamburgerBtn.addEventListener('click', openSidebar);
      if (closeSidebarBtn) closeSidebarBtn.addEventListener('click', closeSidebar);
      if (overlay) overlay.addEventListener('click', closeSidebar);

      // Close sidebar when any link inside is clicked
      if (sidebar) {
        document.querySelectorAll('.sidebar-links a, .sidebar-cta').forEach(link => {
          link.addEventListener('click', closeSidebar);
        });
      }

      // --------------------------------------------------------------
      // 3. SCROLL REVEAL (ensures content becomes visible)
      // --------------------------------------------------------------
      const revealElements = document.querySelectorAll('.reveal');

      // If there are no .reveal elements, add them dynamically to sections
      if (revealElements.length === 0) {
        const sectionsToReveal = document.querySelectorAll('#practice, #special, #cyber, #cta-strip, footer');
        sectionsToReveal.forEach(section => {
          section.classList.add('reveal');
        });
      }

      // Re-query after potential addition
      const finalRevealElements = document.querySelectorAll('.reveal');

      const io = new IntersectionObserver(entries => {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            entry.target.classList.add('in');
            io.unobserve(entry.target);
          }
        });
      }, { threshold: 0.07, rootMargin: '0px 0px -30px 0px' });

      finalRevealElements.forEach(el => io.observe(el));

      // Also manually trigger a check for any visible elements on load
      setTimeout(() => {
        finalRevealElements.forEach(el => {
          const rect = el.getBoundingClientRect();
          if (rect.top < window.innerHeight - 100) {
            el.classList.add('in');
            io.unobserve(el);
          }
        });
      }, 100);

      // --------------------------------------------------------------
      // 4. Add smooth hover effect for practice cards (enhancement)
      // --------------------------------------------------------------
      const practiceCards = document.querySelectorAll('.p-card');
      practiceCards.forEach(card => {
        card.addEventListener('mouseenter', () => {
          card.style.transition = 'all 0.3s ease';
        });
      });

      // --------------------------------------------------------------
      // 5. Fix any missing background images (ensure they exist)
      // --------------------------------------------------------------
      // Check if images load, add fallback background color if needed
      const heroBg = document.querySelector('.hero-bg');
      const cyberBg = document.querySelector('.cyber-art-bg');

      if (heroBg) {
        const img = new Image();
        img.src = '/vnextimages/companyfiles/service.png';
        img.onerror = () => {
          heroBg.style.backgroundColor = '#2a2418';
          heroBg.style.backgroundImage = 'none';
        };
      }

      if (cyberBg) {
        const img = new Image();
        img.src = '/vnextimages/companyfiles/cyber.png';
        img.onerror = () => {
          cyberBg.style.backgroundColor = '#2a2a28';
          cyberBg.style.backgroundImage = 'none';
        };
      }

      // --------------------------------------------------------------
      // 6. Fix any missing CSS transitions or visibility issues
      // --------------------------------------------------------------
      // Ensure all sections are visible by default
      const allSections = document.querySelectorAll('#practice, #special, #cyber, #cta-strip');
      allSections.forEach(section => {
        if (section.style.opacity === '0') {
          section.style.opacity = '1';
        }
      });

      // Force reflow to ensure animations work properly
      document.body.style.display = 'none';
      document.body.offsetHeight; // trigger reflow
      document.body.style.display = '';

    })();
  </script>










 </body>

</html>