<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover" />
  <title>About — VNext Legal | Advocates, Solicitors & Consultants</title>
  <!-- Google Fonts (exactly matching index.html) -->
  <link
    href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,500;0,600;1,300;1,400&family=Didact+Gothic&family=Cinzel:wght@400;500;600&display=swap"
    rel="stylesheet" />
  <style>
    /* ----- GLOBAL RESET & VARIABLES (identical to index.html) ----- */
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

    /* ----- NAVBAR ----- */
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
      box-shadow: rgba(192, 149, 20, 0.68) 0px 3px 8px;
      font-weight: 500;
    }

    .hamburger {
      display: none;
      /* hidden on desktop */
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

    /* =============================================
       RESPONSIVE NAV — THE FIX
       ============================================= */
    @media (max-width: 900px) {
      .nav-links {
        display: none;
      }

      /* hide desktop links */
      .nav-cta {
        display: none;
      }

      /* hide desktop CTA   */
      .hamburger {
        display: flex;
      }

      /* show hamburger      */
    }

    /* ----- SIDEBAR ----- */
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

    /* ----- POPUP ----- */
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

    @media (max-width: 700px) {
      .footer-inner {
        grid-template-columns: 1fr;
        gap: 28px;
      }

      .form-row {
        grid-template-columns: 1fr;
      }
    }

    /* ----- REVEAL ANIMATIONS ----- */
    .reveal {
      opacity: 0;
      transform: translateY(30px);
      transition: opacity 0.7s cubic-bezier(0.4, 0, 0.2, 1), transform 0.7s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .reveal.visible {
      opacity: 1;
      transform: translateY(0);
    }

    .reveal.in {
      opacity: 1;
      transform: translateY(0);
    }

    /* =============================================
       ABOUT PAGE SECTIONS
       ============================================= */
    section {
      width: 100%;
      height: calc(100vh - 76px);
      position: relative;
      overflow: hidden;
    }

    #about {
      height: 100vh;
    }

    /* ══════ S1 — ABOUT ══════ */
    #about {
      display: grid;
      grid-template-columns: 1fr 1fr;
      padding-top: 76px;
    }

    .about-left {
      background: var(--black-soft);
      display: flex;
      flex-direction: column;
      justify-content: center;
      padding: 0 56px 0 5%;
      border-right: 1px solid var(--border-gold);
      position: relative;
    }

    .about-left::after {
      content: '';
      position: absolute;
      top: 8%;
      bottom: 8%;
      right: 0;
      width: 1px;
      background: linear-gradient(180deg, transparent, var(--gold), transparent);
    }

    .ghost-letter {
      position: absolute;
      right: -30px;
      bottom: -60px;
      font-family: var(--font-display);
      font-size: 28vw;
      font-weight: 600;
      color: rgba(201, 168, 76, 0.028);
      line-height: 1;
      pointer-events: none;
      user-select: none;
    }

    .a-eyebrow {
      display: flex;
      align-items: center;
      gap: 12px;
      font-family: var(--font-body);
      font-size: 0.58rem;
      letter-spacing: 0.45em;
      text-transform: uppercase;
      color: var(--gold);
      margin-bottom: 1.4rem;
      opacity: 0;
      animation: up 0.7s 0.3s forwards;
    }

    .a-eyebrow span {
      width: 32px;
      height: 1px;
      background: var(--gold);
      display: block;
    }

    .a-h1 {
      font-family: var(--font-display);
      font-size: clamp(2.4rem, 3.6vw, 4.6rem);
      font-weight: 600;
      letter-spacing: 0.04em;
      line-height: 1;
      color: var(--white);
      position: relative;
      z-index: 1;
      opacity: 0;
      animation: up 0.8s 0.5s forwards;
    }

    .a-h1 em {
      color: var(--gold);
      font-style: normal;
      display: block;
    }

    .a-divider {
      display: flex;
      align-items: center;
      gap: 12px;
      margin: 1.4rem 0;
      opacity: 0;
      animation: up 0.7s 0.7s forwards;
    }

    .a-divider-line {
      width: 48px;
      height: 1px;
      background: var(--border-gold-strong);
    }

    .a-divider-diamond {
      width: 7px;
      height: 7px;
      border: 1px solid var(--gold);
      transform: rotate(45deg);
      animation: spin 6s linear infinite;
    }

    .a-desc {
      /* font-family: var(--font-serif); */
      font-size: clamp(0.92rem, 1.9vw, 1.1rem);
      /* font-style: italic; */
      line-height: 1.9;
      color: rgba(250, 250, 248, 0.997);
      max-width: 440px;
      position: relative;
      z-index: 1;
      opacity: 0;
      animation: up 0.8s 0.9s forwards;
      /* letter-spacing: 0.1rem; */
    }

    .a-tags {
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
      margin-top: 1.4rem;
      position: relative;
      z-index: 1;
      opacity: 0;
      animation: up 0.8s 1.1s forwards;
    }

    .a-tag {
      font-family: var(--font-body);
      font-size: 0.59rem;
      letter-spacing: 0.2em;
      text-transform: uppercase;
      padding: 6px 14px;
      border: 1px solid var(--border-gold);
      color:white;
      transition: all 0.3s;
      font-weight: 600;
    }

    .a-tag:hover {
      border-color: var(--gold);
      color: var(--gold);
      background: rgba(201, 168, 76, 0.06);
    }

    .about-right {
      position: relative;
      overflow: hidden;
    }

    .about-right-img {
      position: absolute;
      inset: 0;
      background: url('https://images.unsplash.com/photo-1589829545856-d10d557cf95f?w=1400&q=85') center/cover;
    }

    .about-right-img::after {
      content: '';
      position: absolute;
      inset: 0;
      background: linear-gradient(135deg, rgba(8, 8, 7, 0.55) 0%, rgba(8, 8, 7, 0.1) 100%);
    }

    .about-float {
      position: absolute;
      bottom: 36px;
      left: 30px;
      right: 30px;
      background: rgba(8, 8, 7, 0.86);
      backdrop-filter: blur(24px);
      border: 1px solid var(--border-gold);
      padding: 18px 22px;
      display: flex;
      align-items: center;
      gap: 16px;
      opacity: 0;
      animation: up 0.9s 1.5s forwards;
    }

    .about-float::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 2px;
      background: linear-gradient(90deg, var(--gold), var(--gold-pale), var(--gold));
    }

    .about-float-icon {
      width: 44px;
      height: 44px;
      flex-shrink: 0;
      border: 1px solid var(--border-gold-strong);
      display: flex;
      align-items: center;
      justify-content: center;
      background: rgba(201, 168, 76, 0.08);
    }

    .about-float-icon svg {
      width: 20px;
      height: 20px;
      stroke: var(--gold);
      fill: none;
      stroke-width: 1.4;
    }

    .about-float-title {
      font-family: var(--font-display);
      font-size: 0.65rem;
      letter-spacing: 0.1em;
      text-transform: uppercase;
      color: var(--gold);
      margin-bottom: 3px;
    }

    .about-float-body {
      /* font-family: var(--font-serif); */
      font-size: 0.89rem;
      /* font-style: italic; */
      color: rgba(250, 250, 248, 0.6);
      line-height: 1.5;
    }

    @media(max-width:900px) {
      #about {
        grid-template-columns: 1fr;
        height: auto;
      }

      .about-left {
        padding: 50px 5%;
        min-height: 60vh;
      }

      .about-right {
        height: 40vh;
      }
    }

    /* ══════ S2 — VISION ══════ */
    #vision {
      display: grid;
      grid-template-columns: 55% 45%;
    }

    .vision-content {
      display: flex;
      flex-direction: column;
      justify-content: center;
      padding: 0 72px 0 5%;
      background: var(--black);
      position: relative;
      overflow: hidden;
    }

    .vision-bg-word {
      position: absolute;
      left: -10px;
      top: 50%;
      transform: translateY(-50%);
      font-family: var(--font-display);
      font-size: 26vw;
      font-weight: 600;
      color: rgba(201, 168, 76, 0.022);
      line-height: 1;
      pointer-events: none;
      white-space: nowrap;
    }

    .v-label {
      display: flex;
      align-items: center;
      gap: 14px;
      font-family: var(--font-body);
      font-size: 0.58rem;
      letter-spacing: 0.5em;
      text-transform: uppercase;
      color: var(--gold);
      margin-bottom: 1.2rem;
      position: relative;
      z-index: 2;
    }

    .v-label-line {
      width: 40px;
      height: 1px;
      background: var(--gold);
    }

    .v-label-num {
      color: var(--border-gold-strong);
      font-family: var(--font-display);
    }

    .v-h2 {
      font-family: var(--font-display);
      font-size: clamp(2.2rem, 3vw, 4.4rem);
      font-weight: 600;
      line-height: 0.92;
      letter-spacing: 0.03em;
      color: var(--white);
      position: relative;
      z-index: 2;
      margin-bottom: 1rem;
    }

    .v-h2 .gold {
      color: var(--gold);
      display: block;
      font-style: italic;
    }

    .v-quote {
      /* font-family: var(--font-serif); */
      font-size: clamp(0.96rem, 1.3vw, 1.2rem);
      line-height: 1.9;
      color: rgba(250, 250, 248, 0.795);
      font-style: italic;
      position: relative;
      z-index: 2;
      padding-left: 20px;
      border-left: 2px solid var(--gold);
      max-width: 480px;
      margin-bottom: 2rem;
    }

    .v-pillars {
      display: flex;
      gap: 0;
      border-top: 1px solid var(--border-gold);
      padding-top: 1.6rem;
      position: relative;
      z-index: 2;
    }

    .v-pillar {
      padding-right: 28px;
      margin-right: 28px;
      border-right: 1px solid var(--border-gold);
    }

    .v-pillar:last-child {
      border: none;
      padding: 0;
      margin: 0;
    }

    .v-pillar-title {
      font-family: var(--font-display);
      font-size: 0.75rem;
      letter-spacing: 0.22em;
      text-transform: uppercase;
      color: var(--gold);
      display: block;
      margin-bottom: 3px;
      font-weight: 800;
    }

    .v-pillar-sub {
      /* font-family: var(--font-serif); */
      font-size: 0.89rem;
      color: white;
      font-style: italic;
    }

    .vision-art {
      position: relative;
      overflow: hidden;
      background: var(--black-mid);
    }

    .vision-art-img {
      position: absolute;
      inset: 0;
      background: url('./images/vision.png') center/cover;
      filter: brightness(0.) saturate(0.9);
      transform: scale(1.08);
      transition: transform 10s ease;
    }

    #vision:hover .vision-art-img {
      transform: scale(1);
    }

    .vision-art-glow {
      position: absolute;
      inset: 0;
      background: radial-gradient(ellipse 80% 60% at 50% 40%, rgba(201, 168, 76, 0.12) 0%, transparent 70%);
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

    .vision-emblem {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 16px;
    }

    .vision-emblem-ring {
      width: 110px;
      height: 110px;
      border-radius: 50%;
      border: 1px solid rgba(239, 238, 233, 0.8);
      display: flex;
      align-items: center;
      justify-content: center;
      position: relative;
    }

    .vision-emblem-ring::before {
      content: '';
      position: absolute;
      inset: 10px;
      border-radius: 50%;
      border: 1px solid rgba(247, 245, 241, 0.6);
      animation: spin 14s linear infinite;
    }

    .vision-emblem-ring svg {
      width: 40px;
      height: 40px;
      stroke: var(--white);
      fill: none;
      stroke-width: 1;
      opacity: 0.7;
    }

    .vision-emblem-label {
      font-family: var(--font-display);
      font-size: 0.55rem;
      letter-spacing: 0.4em;
      text-transform: uppercase;
      color: rgba(237, 234, 227, 0.85);
    }

    .v-vert {
      position: absolute;
      right: 28px;
      top: 50%;
      transform: translateY(-50%) rotate(90deg);
      font-family: var(--font-body);
      font-size: 0.52rem;
      letter-spacing: 0.38em;
      text-transform: uppercase;
      color: rgba(201, 168, 76, 0.35);
      white-space: nowrap;
    }

    @media(max-width:900px) {
      #vision {
        grid-template-columns: 1fr;
        height: auto;
      }

      .vision-content {
        padding: 60px 5%;
        min-height: 55vh;
      }

      .vision-art {
        height: 30vh;
      }
    }

    /* ══════ S3 — MISSION ══════ */
    #mission {
      display: grid;
      grid-template-columns: 42% 58%;
      background: var(--cream);
    }

    .mission-img-panel {
      position: relative;
      overflow: hidden;
      background: var(--black);
      border-right: 1px solid var(--border-gold);
    }

    .mission-bg {
      position: absolute;
      inset: 0;
      background: url('./images/mission\ \(2\).png') center/cover;
      filter: brightness(0.90) saturate(0.9);
    }

    .mission-img-overlay {
      position: absolute;
      inset: 0;
      background: linear-gradient(180deg, rgba(8, 8, 7, 0.2) 0%, rgba(8, 8, 7, 0.7) 100%);
    }

    .m-stat-box {
      position: absolute;
      top: 36px;
      left: 36px;
      background: rgba(8, 8, 7, 0.82);
      backdrop-filter: blur(16px);
      border: 1px solid var(--border-gold);
      padding: 16px 22px;
    }

    .m-stat-box::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 2px;
      background: var(--gold);
    }

    .m-stat-big {
      font-family: var(--font-display);
      font-size: 2.4rem;
      font-weight: 600;
      color: var(--gold);
      line-height: 1;
      display: block;
    }

    .m-stat-sm {
      font-family: var(--font-body);
      font-size: 0.52rem;
      letter-spacing: 0.26em;
      text-transform: uppercase;
      color: rgba(250, 250, 248, 0.5);
      margin-top: 5px;
      display: block;
    }

    .m-img-bottom {
      position: absolute;
      bottom: 36px;
      left: 36px;
      right: 36px;
    }

    .m-img-quote {
      font-family: var(--font-serif);
      font-size: 0.96rem;
      font-style: italic;
      color: rgba(250, 250, 248, 0.5);
      line-height: 1.7;
      border-left: 2px solid rgba(201, 168, 76, 0.4);
      padding-left: 14px;
    }

    .mission-content {
      display: flex;
      flex-direction: column;
      justify-content: center;
      padding: 0 6% 0 60px;
      position: relative;
    }

    .mission-content::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      bottom: 0;
      width: 2px;
      background: linear-gradient(180deg, transparent, var(--gold-dark), transparent);
    }

    .m-label {
      display: flex;
      align-items: center;
      gap: 14px;
      font-family: var(--font-body);
      font-size: 0.58rem;
      letter-spacing: 0.48em;
      text-transform: uppercase;
      color: var(--gold-dark);
      margin-bottom: 0.8rem;
    }

    .m-label-dot {
      width: 6px;
      height: 6px;
      background: var(--gold-dark);
      border-radius: 50%;
    }

    .m-h2 {
      font-family: var(--font-display);
      font-size: clamp(2.2rem, 2.6vw, 4.2rem);
      font-weight: 600;
      line-height: 0.95;
      letter-spacing: 0.03em;
      color: #1a1208;
      margin-bottom: 0.9rem;
    }

    .m-h2 .m-italic {
      color: var(--gold-dark);
      font-style: italic;
      display: block;
    }

    .m-body {
      /* font-family: var(--font-serif); */
      font-size: clamp(0.95rem, 1.7vw, 1.1rem);
      line-height: 1.9;
      color: #5a4e38;
      margin-bottom: 1.2rem;
    }

    .m-pillars {
      display: flex;
      flex-direction: column;
      gap: 0;
    }

    .m-row {
      display: flex;
      align-items: center;
      gap: 0;
      border-top: 1px solid rgba(139, 105, 20, 0.2);
      padding: 11px 0;
      transition: all 0.3s;
      cursor: default;
    }

    .m-row:last-child {
      border-bottom: 1px solid rgba(139, 105, 20, 0.2);
    }

    .m-row:hover {
      padding-left: 8px;
    }

    .m-row-num {
      font-family: var(--font-display);
      font-size: 0.6rem;
      letter-spacing: 0.18em;
      color: var(--gold-dark);
      width: 44px;
      flex-shrink: 0;
      opacity: 0.7;
    }

    .m-row-bar {
      width: 1px;
      height: 24px;
      background: rgba(139, 105, 20, 0.3);
      margin-right: 16px;
      flex-shrink: 0;
    }

    .m-row-text {
      /* font-family: var(--font-body); */
      font-size: 0.79rem;
      letter-spacing: 0.1em;
      text-transform: uppercase;
      color: #3a3020;
      font-weight: 500;
    }

    @media(max-width:900px) {
      #mission {
        grid-template-columns: 1fr;
        height: auto;
        background: var(--cream);
      }

      .mission-img-panel {
        height: 36vh;
      }

      .mission-content {
        padding: 50px 5%;
      }
    }

    /* ══════ S4 — WHY ══════ */
    #why {
      background: var(--black-soft);
      display: flex;
      align-items: center;
      border-top: 1px solid var(--border-gold);
    }

    .why-wrap {
      width: 100%;
      height: 100%;
      display: grid;
      grid-template-columns: 280px 1fr;
      align-items: center;
      padding: 0 5%;
      gap: 72px;
    }

    .why-head {
      position: relative;
      display: flex;
      flex-direction: column;
      justify-content: center;
    }

    .why-head::after {
      content: '';
      position: absolute;
      right: -36px;
      top: 10%;
      bottom: 10%;
      width: 1px;
      background: linear-gradient(180deg, transparent, var(--border-gold-strong), transparent);
    }

    .why-tag {
      display: flex;
      align-items: center;
      gap: 12px;
      font-family: var(--font-body);
      font-size: 0.56rem;
      letter-spacing: 0.46em;
      text-transform: uppercase;
      color: var(--gold);
      margin-bottom: 1.4rem;
    }

    .why-tag::before {
      content: '';
      width: 22px;
      height: 1px;
      background: var(--gold);
    }

    .why-h2 {
      font-family: var(--font-display);
      font-size: clamp(1.8rem, 2.8vw, 3.2rem);
      font-weight: 600;
      color: var(--white);
      line-height: 1.05;
      letter-spacing: 0.03em;
    }

    .why-h2 span {
      color: var(--gold);
      display: block;
    }

    .why-rule {
      width: 38px;
      height: 2px;
      background: linear-gradient(90deg, var(--gold), transparent);
      margin: 1.4rem 0;
    }

    .why-sub {
      font-family: var(--font-serif);
      font-size: 0.99rem;
      font-style: italic;
      color: #cccccc;
      line-height: 1.8;
    }

    .why-list {
      display: flex;
      flex-direction: column;
    }

    .why-item {
      display: flex;
      align-items: center;
      gap: 0;
      border-bottom: 1px solid var(--border-gold);
      padding: 0;
      overflow: hidden;
      position: relative;
      cursor: default;
      transition: background 0.35s;
    }

    .why-item:first-child {
      border-top: 1px solid var(--border-gold);
    }

    .why-item::before {
      content: '';
      position: absolute;
      left: 0;
      top: 0;
      bottom: 0;
      width: 3px;
      background: var(--gold);
      transform: scaleY(0);
      transform-origin: bottom;
      transition: transform 0.35s ease;
    }

    .why-item:hover {
      background: rgba(201, 168, 76, 0.035);
    }

    .why-item:hover::before {
      transform: scaleY(1);
    }

    .w-num {
      font-family: var(--font-display);
      font-size: 0.56rem;
      letter-spacing: 0.18em;
      color: var(--border-gold-strong);
      width: 50px;
      flex-shrink: 0;
      padding: 16px 0 16px 12px;
      transition: color 0.3s;
    }

    .why-item:hover .w-num {
      color: var(--gold);
    }

    .w-icon {
      width: 36px;
      height: 36px;
      flex-shrink: 0;
      border: 1px solid var(--border-gold);
      display: flex;
      align-items: center;
      justify-content: center;
      background: rgba(201, 168, 76, 0.04);
      margin-right: 18px;
      transition: all 0.3s;
    }

    .why-item:hover .w-icon {
      background: rgba(201, 168, 76, 0.1);
      border-color: var(--gold);
    }

    .w-icon svg {
      width: 16px;
      height: 16px;
      stroke: var(--gold);
      fill: none;
      stroke-width: 1.5;
      stroke-linecap: round;
      stroke-linejoin: round;
    }

    .w-body {
      flex: 1;
      padding: 16px 12px 16px 0;
    }

    .w-title {
      font-family: var(--font-body);
      font-size: 0.79rem;
      letter-spacing: 0.1em;
      text-transform: uppercase;
      font-weight: 500;
      color: var(--gold-dark);
      margin-bottom: 2px;
      transition: color 0.3s;
      font-weight: 500;
    }

    .why-item:hover .w-title {
      color: var(--gold);
    }

    .w-desc {
      /* font-family: var(--font-serif); */
      font-size: 0.89rem;
      color: rgba(250, 250, 248, 0.877);
      line-height: 1.45;
      transition: color 0.3s;
    }

    .why-item:hover .w-desc {
      color: rgba(250, 250, 248, 0.65);
    }

    .w-arrow {
      padding: 16px 14px 16px 0;
      flex-shrink: 0;
      opacity: 0;
      transform: translateX(-10px);
      transition: all 0.3s;
    }

    .why-item:hover .w-arrow {
      opacity: 1;
      transform: translateX(0);
    }

    .w-arrow svg {
      width: 14px;
      height: 14px;
      stroke: var(--gold);
      fill: none;
      stroke-width: 1.8;
    }

    @media(max-width:1100px) {
      .why-wrap {
        grid-template-columns: 1fr;
        gap: 28px;
        padding: 50px 5%;
      }

      .why-head::after {
        display: none;
      }
    }

    @media(max-width:900px) {
      #why {
        height: auto;
      }
    }

    /* keyframes */
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

    @keyframes spin {
      to {
        transform: rotate(405deg);
      }
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

    @media (max-width: 900px) {
      section {
        height: auto;
      }

      #about {
        height: auto;
      }
    }
  </style>
</head>

<body>

 <%@ include file="header.jsp" %>



  <!-- ══════ S1 — ABOUT ══════ -->
  <section id="about">
    <div class="about-left">
      <div class="ghost-letter">V</div>
      <div class="a-eyebrow"><span></span>Advocates · Solicitors · Consultants</div>
      <h1 class="a-h1">About<em>VNext</em>Legal LLP</h1>
      <div class="a-divider">
        <div class="a-divider-line"></div>
        <div class="a-divider-diamond"></div>
        <div class="a-divider-line"></div>
      </div>
      <p class="a-desc">A firm of experienced advocates offering bespoke, client-centric legal solutions across India —
        built on three decades of trust.</p>
      <div class="a-tags">
        <div class="a-tag">Surveillance</div>
        <div class="a-tag">Check on Check</div>
        <div class="a-tag">Retainership</div>
        <div class="a-tag">Facilitators</div>
      </div>
    </div>
    <div class="about-right">
      <div class="about-right-img"></div>
      <div class="about-float">
        <div class="about-float-icon">
          <svg viewBox="0 0 24 24">
            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
          </svg>
        </div>
        <div>
          <div class="about-float-title">Trusted Legal Partners</div>
          <div class="about-float-body">Strategic, reliable, result-oriented legal solutions for businesses &amp;
            individuals</div>
        </div>
      </div>
    </div>
  </section>

  <!-- ══════ S2 — VISION ══════ -->
  <section id="vision">
    <div class="vision-content">
      <div class="vision-bg-word">V</div>
      <div class="v-label reveal d1">
        <div class="v-label-line"></div>
        <span>Our Vision</span>
        <span class="v-label-num">— 01</span>
      </div>
      <h2 class="v-h2 reveal d2">
        Legal
        <span class="gold">Excellence</span>
        Without<br>Compromise
      </h2>
      <p class="v-quote reveal d3">
        To provide the best legal services with integrity, excellence, and a global perspective — building a future
        where every client receives justice with unwavering dedication.
      </p>
      <div class="v-pillars reveal d4">
        <div class="v-pillar">
          <span class="v-pillar-title">Integrity</span>
          <span class="v-pillar-sub">Uncompromising</span>
        </div>
        <div class="v-pillar">
          <span class="v-pillar-title">Excellence</span>
          <span class="v-pillar-sub">In every case</span>
        </div>
        <div class="v-pillar">
          <span class="v-pillar-title">Global View</span>
          <span class="v-pillar-sub">Wide perspective</span>
        </div>
      </div>
    </div>
    <div class="vision-art">
      <div class="vision-art-img"></div>
      <div class="vision-art-glow"></div>
      <div class="vc vc-tl"></div>
      <div class="vc vc-tr"></div>
      <div class="vc vc-bl"></div>
      <div class="vc vc-br"></div>
      <div class="vision-emblem">
        <div class="vision-emblem-ring">
          <svg viewBox="0 0 24 24">
            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z" />
            <circle cx="12" cy="12" r="3" />
          </svg>
        </div>
        <div class="vision-emblem-label">VNext Vision</div>
      </div>
      <div class="v-vert">Legal Excellence · Integrity · Global Perspective</div>
    </div>
  </section>

  <!-- ══════ S3 — MISSION ══════ -->
  <section id="mission">
    <div class="mission-img-panel">
      <div class="mission-bg"></div>
      <div class="mission-img-overlay"></div>
      <div class="m-stat-box">
        <span class="m-stat-big">30+</span>
        <span class="m-stat-sm">Years of Mission-Driven Practice</span>
      </div>
      <div class="m-img-bottom">
        <p class="m-img-quote">Every case is a commitment.<br>Every client, a responsibility.</p>
      </div>
    </div>
    <div class="mission-content">
      <div class="m-label reveal d1">
        <div class="m-label-dot"></div>
        Our Mission
        <div class="m-label-dot"></div>
      </div>
      <h2 class="m-h2 reveal d2">
        Purpose
        <span class="m-italic">Driven</span>
        Practice
      </h2>
      <p class="m-body reveal d3">
        To enable solutions that are innovative, practical and lasting — making a positive impact on every client, every
        case, and every community we serve.
      </p>
      <div class="m-pillars reveal d4">
        <div class="m-row"><span class="m-row-num">01</span>
          <div class="m-row-bar"></div><span class="m-row-text">Innovative Legal Solutions</span>
        </div>
        <div class="m-row"><span class="m-row-num">02</span>
          <div class="m-row-bar"></div><span class="m-row-text">Practical &amp; Lasting Outcomes</span>
        </div>
        <div class="m-row"><span class="m-row-num">03</span>
          <div class="m-row-bar"></div><span class="m-row-text">Client-First Approach</span>
        </div>
        <div class="m-row"><span class="m-row-num">04</span>
          <div class="m-row-bar"></div><span class="m-row-text">Positive Community Impact</span>
        </div>
      </div>
    </div>
  </section>

  <!-- ══════ S4 — WHY CHOOSE US ══════ -->
  <section id="why">
    <div class="why-wrap">
      <div class="why-head reveal">
        <div class="why-tag">Why Choose Us</div>
        <h2 class="why-h2">Our<span>Competitive</span>Advantage</h2>
        <div class="why-rule"></div>
        <p class="why-sub">Six reasons why India's leading businesses and individuals trust VNext Legal for their most
          critical matters.</p>
      </div>
      <div class="why-list reveal d2">
        <div class="why-item">
          <span class="w-num">01</span>
          <div class="w-icon"><svg viewBox="0 0 24 24">
              <rect x="2" y="3" width="20" height="14" rx="2" />
              <line x1="8" y1="21" x2="16" y2="21" />
              <line x1="12" y1="17" x2="12" y2="21" />
            </svg></div>
          <div class="w-body">
            <div class="w-title">Industry-Specific Expertise</div>
            <div class="w-desc">Specialists across surveillance, compliance, and corporate law — precise, context-aware
              counsel every time.</div>
          </div>
          <!-- <div class="w-arrow"><svg viewBox="0 0 24 24">
              <path d="M5 12h14M12 5l7 7-7 7" />
            </svg></div> -->
        </div>
        <div class="why-item">
          <span class="w-num">02</span>
          <div class="w-icon"><svg viewBox="0 0 24 24">
              <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
            </svg></div>
          <div class="w-body">
            <div class="w-title">Confidential &amp; Discreet</div>
            <div class="w-desc">Client confidentiality is not a policy — it is our professional oath, upheld at every
              stage.</div>
          </div>
          <!-- <div class="w-arrow"><svg viewBox="0 0 24 24">
              <path d="M5 12h14M12 5l7 7-7 7" />
            </svg></div> -->
        </div>
        <div class="why-item">
          <span class="w-num">03</span>
          <div class="w-icon"><svg viewBox="0 0 24 24">
              <circle cx="12" cy="12" r="10" />
              <line x1="2" y1="12" x2="22" y2="12" />
              <path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z" />
            </svg></div>
          <div class="w-body">
            <div class="w-title">Pan-India Jurisdiction</div>
            <div class="w-desc">Seamless nationwide presence — local knowledge, national strength, wherever your matter
              demands.</div>
          </div>
          <!-- <div class="w-arrow"><svg viewBox="0 0 24 24">
              <path d="M5 12h14M12 5l7 7-7 7" />
            </svg></div> -->
        </div>
        <div class="why-item">
          <span class="w-num">04</span>
          <div class="w-icon"><svg viewBox="0 0 24 24">
              <polyline points="22 12 18 12 15 21 9 3 6 12 2 12" />
            </svg></div>
          <div class="w-body">
            <div class="w-title">Result-Oriented Strategy</div>
            <div class="w-desc">Every strategy built around measurable outcomes — minimizing risk while maximizing your
              position.</div>
          </div>
          <!-- <div class="w-arrow"><svg viewBox="0 0 24 24">
              <path d="M5 12h14M12 5l7 7-7 7" />
            </svg></div> -->
        </div>
        <div class="why-item">
          <span class="w-num">05</span>
          <div class="w-icon"><svg viewBox="0 0 24 24">
              <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
              <circle cx="9" cy="7" r="4" />
              <path d="M23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75" />
            </svg></div>
          <div class="w-body">
            <div class="w-title">Bespoke Client Approach</div>
            <div class="w-desc">No two clients alike — we craft a legal framework built entirely around your goals and
              risk tolerance.</div>
          </div>
          <!-- <div class="w-arrow"><svg viewBox="0 0 24 24">
              <path d="M5 12h14M12 5l7 7-7 7" />
            </svg></div> -->
        </div>
        <div class="why-item">
          <span class="w-num">06</span>
          <div class="w-icon"><svg viewBox="0 0 24 24">
              <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14" />
              <polyline points="22 4 12 14.01 9 11.01" />
            </svg></div>
          <div class="w-body">
            <div class="w-title">30+ Years of Trust</div>
            <div class="w-desc">Three decades of consistent, ethical practice — a reputation that speaks across
              industries and jurisdictions.</div>
          </div>
          <!-- <div class="w-arrow"><svg viewBox="0 0 24 24">
              <path d="M5 12h14M12 5l7 7-7 7" />
            </svg></div> -->
        </div>
      </div>
    </div>
  </section>


  <%@ include file="footer.jsp" %>

  <script>
(function() {
    // ========== NAVBAR SCROLL EFFECT ==========
    const nav = document.getElementById('navbar');
    if (nav) {
        window.addEventListener('scroll', function() {
            nav.classList.toggle('scrolled', window.scrollY > 60);
        });
    }

    // ========== SIDEBAR LOGIC ==========
    const hamburgerBtn = document.getElementById('hamburgerBtn');
    const sidebar = document.getElementById('sidebarNav');
    const overlay = document.getElementById('sidebarOverlay');
    const closeSidebarBtn = document.getElementById('closeSidebarBtn');

    function openSidebar() {
        if (sidebar) sidebar.classList.add('open');
        if (overlay) overlay.classList.add('active');
        document.body.style.overflow = 'hidden';
    }

    function closeSidebar() {
        if (sidebar) sidebar.classList.remove('open');
        if (overlay) overlay.classList.remove('active');
        document.body.style.overflow = '';
    }

    if (hamburgerBtn) hamburgerBtn.addEventListener('click', openSidebar);
    if (closeSidebarBtn) closeSidebarBtn.addEventListener('click', closeSidebar);
    if (overlay) overlay.addEventListener('click', closeSidebar);

    // Close sidebar when clicking any link
    document.querySelectorAll('.sidebar-links a, .sidebar-cta').forEach(function(link) {
        link.addEventListener('click', closeSidebar);
    });

    // ========== REVEAL ANIMATIONS (INTERSECTION OBSERVER) ==========
    const revealElements = document.querySelectorAll('.reveal');

    if (revealElements.length > 0) {
        const observer = new IntersectionObserver(function(entries) {
            entries.forEach(function(entry) {
                if (entry.isIntersecting) {
                    entry.target.classList.add('visible');
                    entry.target.classList.add('in');
                    observer.unobserve(entry.target); // Stop observing once visible
                }
            });
        }, {
            threshold: 0.1,      // Trigger when 10% of element is visible
            rootMargin: '0px 0px -50px 0px'  // Slightly offset
        });

        revealElements.forEach(function(el) {
            observer.observe(el);
        });
    }

    // ========== POPUP LOGIC ==========
    const popupOverlay = document.getElementById('popupOverlay');
    const popupCloseBtn = document.getElementById('popupClose');

    function openPopup() {
        if (popupOverlay) {
            popupOverlay.classList.add('open');
            document.body.style.overflow = 'hidden';
        }
    }

    function closePopup() {
        if (popupOverlay) {
            popupOverlay.classList.remove('open');
            document.body.style.overflow = '';
        }
    }

    // Add click listeners to all consultation triggers
    const consultTriggers = document.querySelectorAll('.consult-trigger');
    consultTriggers.forEach(function(trigger) {
        trigger.addEventListener('click', function(e) {
            e.preventDefault();
            openPopup();
        });
    });

    // Close popup on button click
    if (popupCloseBtn) {
        popupCloseBtn.addEventListener('click', closePopup);
    }

    // Close popup when clicking outside
    if (popupOverlay) {
        popupOverlay.addEventListener('click', function(e) {
            if (e.target === popupOverlay) {
                closePopup();
            }
        });
    }

    // Close popup with Escape key
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closePopup();
        }
    });

    // ========== FIX FOR VH ISSUES ON MOBILE ==========
    function setVH() {
        let vh = window.innerHeight * 0.01;
        document.documentElement.style.setProperty('--vh', vh + 'px');
    }

    // Fix for mobile browsers (optional, helps with 100vh issues)
    setVH();
    window.addEventListener('resize', setVH);

    // Force sections to be visible if they're hidden (fallback)
    setTimeout(function() {
        const sections = document.querySelectorAll('section');
        sections.forEach(function(section) {
            if (section && section.style) {
                // Ensure sections are visible
                section.style.display = '';
                section.style.visibility = 'visible';
                section.style.opacity = '1';
            }
        });
    }, 100);

})();
</script>







</body>

</html>