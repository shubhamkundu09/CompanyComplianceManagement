<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover" />
  <title>Contact Us — VNext Legal</title>
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
      --black-soft: #0f0f0d;
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

    .nav-links a:hover,
    .nav-links a.active {
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

    .popup .form-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 14px;
      margin-bottom: 14px;
    }

    .popup .form-input,
    .popup .form-textarea {
      background: rgba(250, 250, 248, 0.04);
      border: 1px solid var(--border-gold);
      color: var(--white);
      padding: 12px 14px;
      width: 100%;
      border-radius: 17px;
      font-size: 0.85rem;
      outline: none;
    }

    .popup .form-textarea {
      min-height: 90px;
      resize: vertical;
    }

    .popup .form-submit {
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
      color: var(--black);
    }

    .popup .form-submit:hover {
      background: var(--gold-light);
    }

    @media (max-width: 600px) {
      .popup .form-row {
        grid-template-columns: 1fr;
      }
    }

    /* ════════════════ HERO ════════════════ */
    #hero {
      width: 100%;
      min-height: 60vh;
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

    .ghost-c {
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
      background: url('./images/contact.png') center/cover;
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

    /* Hero emblem */
    .hero-emblem {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 16px;
      z-index: 2;
    }

    .hero-ring {
      width: 110px;
      height: 110px;
      border-radius: 50%;
      border: 1px solid rgba(201, 168, 76, 0.5);
      display: flex;
      align-items: center;
      justify-content: center;
      position: relative;
    }

    .hero-ring::before {
      content: '';
      position: absolute;
      inset: 12px;
      border-radius: 50%;
      border: 1px dashed rgba(201, 168, 76, 0.25);
      animation: spin 10s linear infinite;
    }

    .hero-ring svg {
      width: 42px;
      height: 42px;
      stroke: var(--gold);
      fill: none;
      stroke-width: 1.2;
      opacity: 0.7;
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

    @media(max-width: 900px) {
      #hero {
        grid-template-columns: 1fr;
      }

      .hero-left {
        padding: 60px 5%;
        min-height: 55vh;
      }

      .hero-right {
        height: 38vh;
      }

      .ghost-c {
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
      color: var(--gold-dark);
      margin-bottom: 0.6rem;
      font-weight: 900;
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
      color: black;
      line-height: 1;
    }

    .sec-h2 em {
      color: var(--gold);
      font-style: italic;
      font-weight: 900;
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

    /* ════════════════ CONTACT SECTION ════════════════ */
    #contact {
      background: white;
      border-top: 1px solid var(--border);
      padding-bottom: 60px;
    }

    .contact-wrap {
      display: grid;
      grid-template-columns: 1fr 1.55fr;
      gap: 1px;
      background: var(--border);
      margin: 0 5%;
      border: 1px solid var(--border);
    }

    /* INFO PANEL */
    .contact-info {
      background: var(--black-mid);
      padding: 36px 40px;
      display: flex;
      flex-direction: column;
      position: relative;
      overflow: hidden;
    }

    .contact-info-bg {
      position: absolute;
      inset: 0;
      background: url('https://images.unsplash.com/photo-1589829545856-d10d557cf95f?w=800&q=70') center/cover;
      filter: brightness(0.11) saturate(0.2);
      pointer-events: none;
    }

    .contact-info-glow {
      position: absolute;
      inset: 0;
      background: radial-gradient(ellipse 80% 50% at 50% 20%, rgba(201, 168, 76, 0.1) 0%, transparent 70%);
      pointer-events: none;
    }

    .info-label {
      position: relative;
      display: flex;
      align-items: center;
      gap: 12px;
      font-family: var(--font-body);
      font-size: 0.56rem;
      letter-spacing: 0.48em;
      text-transform: uppercase;
      color: var(--gold);
      margin-bottom: 1.6rem;
    }

    .info-label::before {
      content: '';
      width: 24px;
      height: 1px;
      background: var(--gold);
    }

    .info-heading {
      position: relative;
      font-family: var(--font-display);
      font-size: clamp(1.5rem, 2.4vw, 2.4rem);
      font-weight: 600;
      color: var(--white);
      line-height: 1.1;
      letter-spacing: 0.04em;
      margin-bottom: 1.2rem;
    }

    .info-heading span {
      color: var(--gold);
      display: block;
    }

    .info-desc {
      position: relative;
      /* font-family: var(--font-serif); */
      font-size: 0.95rem;
      color: rgba(250, 250, 248, 0.881);
      line-height: 1.9;
      font-style: italic;
      margin-bottom: 1.4rem;
      border-left: 2px solid rgba(201, 168, 76, 0.35);
      padding-left: 16px;
    }

    .info-items {
      position: relative;
      display: flex;
      flex-direction: column;
    }

    .info-item {
      display: flex;
      align-items: flex-start;
      gap: 16px;
      padding: 18px 0;
      border-bottom: 1px solid var(--border);
      transition: all 0.3s;
    }

    .info-item:first-child {
      border-top: 1px solid var(--border);
    }

    .info-item:hover {
      padding-left: 6px;
    }

    .info-icon-wrap {
      width: 44px;
      height: 44px;
      flex-shrink: 0;
      border: 1px solid var(--border);
      display: flex;
      align-items: center;
      justify-content: center;
      background: rgba(201, 168, 76, 0.06);
      transition: all 0.3s;
    }

    .info-item:hover .info-icon-wrap {
      border-color: var(--gold);
      background: rgba(201, 168, 76, 0.12);
    }

    .info-icon-wrap svg {
      width: 20px;
      height: 20px;
      stroke: var(--gold);
      fill: none;
      stroke-width: 1.4;
      stroke-linecap: round;
      stroke-linejoin: round;
    }

    .info-item-label {
      font-family: var(--font-body);
      font-size: 0.58rem;
      letter-spacing: 0.22em;
      text-transform: uppercase;
      color: var(--gold);
      margin-bottom: 3px;
    }

    .info-item-value {
      /* font-family: var(--font-serif); */
      font-size: 0.96rem;
      color: rgba(250, 250, 248, 0.75);
      line-height: 1.6;
    }

    .info-item-value a {
      color: inherit;
      text-decoration: none;
      transition: color 0.3s;
    }

    .info-item-value a:hover {
      color: var(--gold);
    }

    .avail-badge {
      position: relative;
      margin-top: 2rem;
      display: flex;
      align-items: center;
      gap: 10px;
      font-family: var(--font-body);
      font-size: 0.6rem;
      letter-spacing: 0.14em;
      text-transform: uppercase;
      color: rgba(250, 250, 248, 0.4);
    }

    .avail-dot {
      width: 8px;
      height: 8px;
      border-radius: 50%;
      background: #4ade80;
      box-shadow: 0 0 10px rgba(74, 222, 128, 0.6);
      animation: pulse-dot 2s ease-in-out infinite;
    }

    @keyframes pulse-dot {

      0%,
      100% {
        box-shadow: 0 0 6px rgba(74, 222, 128, 0.5);
      }

      50% {
        box-shadow: 0 0 16px rgba(74, 222, 128, 0.9);
      }
    }

    /* FORM PANEL */
    .contact-form-wrap {
      background: var(--black-soft);
      padding: 36px 52px;
    }

    .form-head-title {
      font-family: var(--font-display);
      font-size: clamp(1.4rem, 2.2vw, 2.2rem);
      font-weight: 600;
      color: var(--white);
      letter-spacing: 0.04em;
      margin-bottom: 0.4rem;
      line-height: 1.1;
    }

    .form-head-title em {
      color: var(--gold);
      font-style: italic;
    }

    .form-head-sub {
      font-family: var(--font-serif);
      font-size: 0.94rem;
      font-style: italic;
      color: rgba(250, 250, 248, 0.4);
      margin-bottom: 1.2rem;
      line-height: 1.7;
    }

    .form-divider {
      display: flex;
      align-items: center;
      gap: 12px;
      margin-bottom: 1.2rem;
    }

    .form-divider-line {
      flex: 1;
      height: 1px;
      background: var(--border);
    }

    .form-divider-diamond {
      width: 6px;
      height: 6px;
      border: 1px solid var(--gold);
      transform: rotate(45deg);
    }

    .form-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 16px;
      margin-bottom: 14px;
    }

    .form-row.single {
      grid-template-columns: 1fr;
    }

    .form-group {
      display: flex;
      flex-direction: column;
      gap: 7px;
    }

    .form-label {
      font-family: var(--font-body);
      font-size: 0.58rem;
      letter-spacing: 0.22em;
      text-transform: uppercase;
      color: rgba(250, 250, 248, 0.5);
    }

    .req {
      color: var(--gold);
    }

    .form-input,
    .form-select,
    .form-textarea {
      background: rgba(201, 168, 76, 0.04);
      border: 1px solid var(--border);
      color: var(--white);
      font-family: var(--font-serif);
      font-size: 1rem;
      padding: 13px 16px;
      outline: none;
      transition: border-color 0.3s, background 0.3s, box-shadow 0.3s;
      width: 100%;
      border-radius: 10px;
    }

    .form-input::placeholder,
    .form-textarea::placeholder {
      color: rgba(250, 250, 248, 0.2);
      font-style: italic;
    }

    .form-input:focus,
    .form-select:focus,
    .form-textarea:focus {
      border-color: var(--gold);
      background: rgba(201, 168, 76, 0.07);
      box-shadow: 0 0 0 1px rgba(201, 168, 76, 0.2), inset 0 0 20px rgba(201, 168, 76, 0.03);
    }

    .form-select {
      cursor: pointer;
      appearance: none;
      background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='8' viewBox='0 0 12 8'%3E%3Cpath d='M1 1l5 5 5-5' stroke='%23C9A84C' stroke-width='1.5' fill='none' stroke-linecap='round'/%3E%3C/svg%3E");
      background-repeat: no-repeat;
      background-position: right 16px center;
    }

    .form-select option {
      background: var(--black-mid);
      color: var(--white);
    }

    .form-textarea {
      resize: vertical;
      min-height: 90px;
      line-height: 1.7;
    }

    .form-submit {
      width: 100%;
      margin-top: 14px;
      padding: 16px 32px;
      background: transparent;
      border: 1px solid var(--gold);
      color: var(--gold);
      font-family: var(--font-body);
      font-size: 0.7rem;
      letter-spacing: 0.22em;
      text-transform: uppercase;
      font-weight: 500;
      cursor: pointer;
      transition: all 0.35s;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 12px;
      border-radius: 10px;
      box-shadow: 0 0 20px rgba(201, 168, 76, 0.1);
      position: relative;
      overflow: hidden;
    }

    .form-submit::before {
      content: '';
      position: absolute;
      left: -100%;
      top: 0;
      bottom: 0;
      width: 100%;
      background: var(--gold);
      transition: left 0.4s ease;
      z-index: 0;
    }

    .form-submit:hover::before {
      left: 0;
    }

    .form-submit span {
      position: relative;
      z-index: 1;
      transition: color 0.35s;
    }

    .form-submit:hover span {
      color: var(--black);
    }

    .form-submit svg {
      position: relative;
      z-index: 1;
      width: 16px;
      height: 16px;
      stroke: currentColor;
      fill: none;
      stroke-width: 1.8;
      stroke-linecap: round;
      stroke-linejoin: round;
      transition: color 0.35s, transform 0.35s;
    }

    .form-submit:hover svg {
      color: var(--black);
      transform: translateX(4px);
    }

    /* success */
    .form-success {
      display: none;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      gap: 16px;
      padding: 40px;
      text-align: center;
    }

    .form-success.show {
      display: flex;
    }

    .success-ring {
      width: 72px;
      height: 72px;
      border-radius: 50%;
      border: 1px solid rgba(201, 168, 76, 0.4);
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .success-ring svg {
      width: 32px;
      height: 32px;
      stroke: var(--gold);
      fill: none;
      stroke-width: 1.5;
    }

    .success-title {
      font-family: var(--font-display);
      font-size: 1.5rem;
      color: var(--gold);
      letter-spacing: 0.06em;
    }

    .success-desc {
      font-family: var(--font-serif);
      font-size: 1rem;
      font-style: italic;
      color: rgba(250, 250, 248, 0.5);
      line-height: 1.7;
    }

    @media(max-width: 1000px) {
      .contact-wrap {
        grid-template-columns: 1fr;
      }

      .contact-form-wrap {
        padding: 36px 5%;
      }

      .contact-info {
        padding: 36px 5%;
      }
    }

    @media(max-width: 640px) {
      .form-row {
        grid-template-columns: 1fr;
      }
    }

    /* ════════════════ MAP STRIP ════════════════ */
    #map-strip {
      background: var(--black);
      border-top: 1px solid var(--border);
      padding: 0;
      overflow: hidden;
    }

    .map-inner {
      display: grid;
      grid-template-columns: 1fr 2fr;
      margin: 0 5% 30px;
      border: 1px solid var(--border);
      border-top: none;
    }

    .map-sidebar {
      background: var(--black-mid);
      padding: 40px 36px;
      border-right: 1px solid var(--border);
      display: flex;
      flex-direction: column;
      justify-content: center;
      gap: 20px;
    }

    .map-tag {
      font-family: var(--font-body);
      font-size: 0.55rem;
      letter-spacing: 0.44em;
      text-transform: uppercase;
      color: var(--gold);
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .map-tag::before {
      content: '';
      width: 20px;
      height: 1px;
      background: var(--gold);
    }

    .map-title {
      font-family: var(--font-display);
      font-size: clamp(1.2rem, 2vw, 1.8rem);
      font-weight: 600;
      color: var(--white);
      line-height: 1.2;
    }

    .map-title em {
      color: var(--gold);
      font-style: italic;
    }

    .map-address {
      font-family: var(--font-serif);
      font-size: 0.96rem;
      color: rgba(250, 250, 248, 0.5);
      line-height: 1.8;
      font-style: italic;
      border-left: 2px solid rgba(201, 168, 76, 0.3);
      padding-left: 14px;
    }

    .map-frame {
      min-height: 300px;
      background: var(--black-mid);
      filter: brightness(0.85) saturate(0.4) contrast(1.1);
      position: relative;
    }

    .map-frame iframe {
      width: 100%;
      height: 100%;
      min-height: 300px;
      border: none;
      display: block;
    }

    .map-frame-overlay {
      position: absolute;
      inset: 0;
      background: linear-gradient(135deg, rgba(201, 168, 76, 0.04) 0%, transparent 50%);
      pointer-events: none;
    }

    @media(max-width: 860px) {
      .map-inner {
        grid-template-columns: 1fr;
      }

      .map-sidebar {
        border-right: none;
        border-bottom: 1px solid var(--border);
      }
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

    @media(max-width: 900px) {
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
  </style>
</head>

<body>

     <%@ include file="header.jsp" %>



  <!-- HERO -->
  <section id="hero">
    <div class="hero-left">
      <div class="ghost-c">C</div>
      <div class="h-eyebrow"><span></span>Get In Touch</div>
      <h1 class="h-h1">Contact<em>Us</em></h1>
      <div class="h-divider">
        <div class="h-divider-line"></div>
        <div class="h-divider-diamond"></div>
        <div class="h-divider-line"></div>
      </div>
      <p class="h-desc">Reach out to V-Next Legal LLP for a consultation. Our team of experienced advocates is ready to
        guide you through your legal challenges with precision and care.</p>
      <div class="h-tagline">Integrity · Expertise · Commitment</div>
    </div>
    <div class="hero-right">
      <div class="hero-bg"></div>
      <div class="hero-glow"></div>
      <div class="vc vc-tl"></div>
      <div class="vc vc-tr"></div>
      <div class="vc vc-bl"></div>
      <div class="vc vc-br"></div>
      <div class="hero-emblem">
        <div class="hero-ring">
          <svg viewBox="0 0 24 24">
            <path
              d="M22 16.92v3a2 2 0 01-2.18 2 19.79 19.79 0 01-8.63-3.07A19.5 19.5 0 014.18 11.82 19.79 19.79 0 011.11 3.2 2 2 0 013.09 1h3a2 2 0 012 1.72c.127.96.361 1.903.7 2.81a2 2 0 01-.45 2.11L7.09 8.91a16 16 0 006 6l1.27-1.27a2 2 0 012.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0122 16.92z" />
          </svg>
        </div>
      </div>
    </div>
  </section>

  <!-- CONTACT SECTION -->
  <section id="contact">
    <div class="sec-header reveal">
      <div class="sec-eyebrow">Reach Out</div>
      <h2 class="sec-h2">Book a <em>Consultation</em></h2>
      <div class="sec-rule"></div>
      <p class="sec-sub">Fill in the form below and our legal specialists will respond within 24 hours — confidentially
        and without obligation.</p>
    </div>

    <div class="contact-wrap reveal d1">

      <!-- INFO PANEL -->
      <div class="contact-info">
        <div class="contact-info-bg"></div>
        <div class="contact-info-glow"></div>

        <div class="info-label">Contact Information</div>
        <div class="info-heading">We are<span>Here for You</span></div>
        <p class="info-desc">Every legal matter deserves undivided attention. Reach us through any channel and we'll
          connect you with the right advocate.</p>

        <div class="info-items">
          <div class="info-item">
            <div class="info-icon-wrap">
              <svg viewBox="0 0 24 24">
                <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z" />
                <circle cx="12" cy="10" r="3" />
              </svg>
            </div>
            <div class="info-item-body">
              <div class="info-item-label">Address</div>
              <div class="info-item-value">BH-1108 Eleventh Floor,<br>Puri High Street,<br>Sector 81, Faridabad</div>
            </div>
          </div>
          <div class="info-item">
            <div class="info-icon-wrap">
              <svg viewBox="0 0 24 24">
                <path
                  d="M22 16.92v3a2 2 0 01-2.18 2 19.79 19.79 0 01-8.63-3.07A19.5 19.5 0 014.18 11.82 19.79 19.79 0 011.11 3.2 2 2 0 013.09 1h3a2 2 0 012 1.72c.127.96.361 1.903.7 2.81a2 2 0 01-.45 2.11L7.09 8.91a16 16 0 006 6l1.27-1.27a2 2 0 012.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0122 16.92z" />
              </svg>
            </div>
            <div class="info-item-body">
              <div class="info-item-label">Phone</div>
              <div class="info-item-value"><a href="tel:+919811625631">+91 98116 25631</a></div>
            </div>
          </div>
          <div class="info-item">
            <div class="info-icon-wrap">
              <svg viewBox="0 0 24 24">
                <path
                  d="M22 16.92v3a2 2 0 01-2.18 2 19.79 19.79 0 01-8.63-3.07A19.5 19.5 0 014.18 11.82 19.79 19.79 0 011.11 3.2 2 2 0 013.09 1h3a2 2 0 012 1.72c.127.96.361 1.903.7 2.81a2 2 0 01-.45 2.11L7.09 8.91a16 16 0 006 6l1.27-1.27a2 2 0 012.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0122 16.92z" />
              </svg>
            </div>
            <div class="info-item-body">
              <div class="info-item-label">Phone</div>
              <div class="info-item-value"><a href="tel:+919818454150">+91 98184 54150</a></div>
            </div>
          </div>
        </div>

        <div class="avail-badge">
          <div class="avail-dot"></div>
          Available for consultations
        </div>
      </div>

      <!-- FORM PANEL -->
      <div class="contact-form-wrap">
        <div class="form-head-title">Book an <em>Appointment</em></div>
        <div class="form-head-sub">Connect with our legal specialists — we'll respond within 24 hours, in complete
          confidence.</div>

        <div class="form-divider">
          <div class="form-divider-line"></div>
          <div class="form-divider-diamond"></div>
          <div class="form-divider-line"></div>
        </div>

        <div id="contactForm">
          <div class="form-row">
            <div class="form-group">
              <label class="form-label">First Name <span class="req">*</span></label>
              <input type="text" class="form-input" id="firstName" placeholder="First name" />
            </div>
            <div class="form-group">
              <label class="form-label">Last Name <span class="req">*</span></label>
              <input type="text" class="form-input" id="lastName" placeholder="Last name" />
            </div>
          </div>
          <div class="form-row">
            <div class="form-group">
              <label class="form-label">Email Address <span class="req">*</span></label>
              <input type="email" class="form-input" id="email" placeholder="your@email.com" />
            </div>
            <div class="form-group">
              <label class="form-label">Phone Number <span class="req">*</span></label>
              <input type="tel" class="form-input" id="phone" placeholder="+91 00000 00000" />
            </div>
          </div>
          <div class="form-row single">
            <div class="form-group">
              <label class="form-label">Practice Area <span class="req">*</span></label>
              <select class="form-select" id="service">
                <option value="" disabled selected>Select an area of practice</option>
                <option>Supreme Court &amp; High Courts</option>
                <option>Arbitration &amp; Mediation</option>
                <option>Intellectual Property Rights</option>
                <option>Direct Taxes</option>
                <option>Indirect Taxes / GST</option>
                <option>Criminal Laws</option>
                <option>Labour Laws</option>
                <option>Corporate Laws</option>
                <option>Land &amp; Real Estate</option>
                <option>NCLT / IBC / PMLA</option>
                <option>Cyber Law</option>
                <option>Electricity Matters</option>
                <option>General Legal Advisory</option>
              </select>
            </div>
          </div>
          <div class="form-row single">
            <div class="form-group">
              <label class="form-label">Message / Brief Description</label>
              <textarea class="form-textarea" id="message"
                placeholder="Briefly describe your legal requirement or concern..."></textarea>
            </div>
          </div>
          <button class="form-submit" id="submitBtn">
            <span>Submit Consultation Request</span>
            <svg viewBox="0 0 24 24">
              <line x1="5" y1="12" x2="19" y2="12" />
              <polyline points="12 5 19 12 12 19" />
            </svg>
          </button>
        </div>

        <div class="form-success" id="formSuccess">
          <div class="success-ring">
            <svg viewBox="0 0 24 24">
              <path d="M22 11.08V12a10 10 0 11-5.93-9.14" />
              <polyline points="22 4 12 14.01 9 11.01" />
            </svg>
          </div>
          <div class="success-title">Request Submitted</div>
          <div class="success-desc">Thank you for reaching out to VNext Legal LLP.<br>Our team will contact you within 24
            hours.</div>
        </div>
      </div>

    </div>
  </section>

  <!-- MAP STRIP -->
  <section id="map-strip">
    <div class="map-inner reveal">
      <div class="map-sidebar">
        <div class="map-tag">Our Location</div>
        <div class="map-title">Find Us<em> in Faridabad</em></div>
        <div class="map-address">
          VNext Legal LLP<br>
          Your Trusted Legal Partner<br>
          Expert Guidance for Every Matter
        </div>
      </div>
      <div class="map-frame">
        <iframe
          src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2152.279755950481!2d77.33895654793824!3d28.39272713227096!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x390cdcf08cfdda29%3A0x21da596d98f11d91!2sPuri%20High%20Street%2C%20Sector%2081%2C%20Faridabad%2C%20Haryana%20121007!5e0!3m2!1sen!2sin!4v1780984639220!5m2!1sen!2sin"
          width="600" height="450" style="border:0;" allowfullscreen="" loading="lazy"
          referrerpolicy="no-referrer-when-downgrade"></iframe>
        <div class="map-frame-overlay"></div>
      </div>
    </div>
  </section>


     <%@ include file="footer.jsp" %>


    <script>
    (function () {
      // Navbar scroll
      const nav = document.getElementById('navbar');
      window.addEventListener('scroll', () => { nav.classList.toggle('scrolled', window.scrollY > 60); });

      // Sidebar
      const hamburgerBtn = document.getElementById('hamburgerBtn');
      const sidebar = document.getElementById('sidebarNav');
      const overlay = document.getElementById('sidebarOverlay');
      const closeSidebarBtn = document.getElementById('closeSidebarBtn');

      function openSidebar() { sidebar.classList.add('open'); overlay.classList.add('active'); document.body.style.overflow = 'hidden'; }
      function closeSidebar() { sidebar.classList.remove('open'); overlay.classList.remove('active'); document.body.style.overflow = ''; }

      hamburgerBtn.addEventListener('click', openSidebar);
      closeSidebarBtn.addEventListener('click', closeSidebar);
      overlay.addEventListener('click', closeSidebar);
      document.querySelectorAll('.sidebar-links a').forEach(link => {
        link.addEventListener('click', closeSidebar);
      });

      // Scroll reveal
      const io = new IntersectionObserver(entries => {
        entries.forEach(e => { if (e.isIntersecting) { e.target.classList.add('in'); io.unobserve(e.target); } });
      }, { threshold: 0.07, rootMargin: '0px 0px -30px 0px' });
      document.querySelectorAll('.reveal').forEach(el => io.observe(el));



      // Contact form submit
      document.getElementById('submitBtn').addEventListener('click', function () {
        const firstName = document.getElementById('firstName').value.trim();
        const lastName = document.getElementById('lastName').value.trim();
        const email = document.getElementById('email').value.trim();
        const phone = document.getElementById('phone').value.trim();
        const service = document.getElementById('service').value;

        const fields = [
          { el: document.getElementById('firstName'), val: firstName },
          { el: document.getElementById('lastName'), val: lastName },
          { el: document.getElementById('email'), val: email },
          { el: document.getElementById('phone'), val: phone },
          { el: document.getElementById('service'), val: service }
        ];

        let hasError = false;
        fields.forEach(({ el, val }) => {
          if (!val) {
            hasError = true;
            el.style.borderColor = 'rgba(255,80,80,0.6)';
            el.style.boxShadow = '0 0 0 1px rgba(255,80,80,0.2)';
            setTimeout(() => { el.style.borderColor = ''; el.style.boxShadow = ''; }, 2000);
          }
        });

        if (hasError) return;

        document.getElementById('contactForm').style.display = 'none';
        document.getElementById('formSuccess').classList.add('show');
      });
    })();
  </script>

</body>

</html>