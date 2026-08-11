<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Our Team — VNext Legal</title>
  <link
    href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;500;600&family=Cormorant+Garamond:ital,wght@0,400;0,500;0,600;1,400;1,500&family=Didact+Gothic&display=swap"
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

      /* unified spacing scale */
      --gap-xs: 8px;
      --gap-sm: 16px;
      --gap-md: 20px;
      --gap-lg: 51px;
      --gap-xl: 44px;
    }

    html {
      scroll-behavior: smooth;
    }

    body {
      background: var(--black);
      color: var(--white);
      font-family: var(--font-body);
      font-size: 15px;
      line-height: 1.7;
      overflow-x: hidden;
    }

    /* ─── reveal-on-scroll ─── */
    @media (prefers-reduced-motion: no-preference) {
      .reveal {
        opacity: 0;
        transform: translateY(18px);
        transition: opacity .7s ease, transform .7s ease;
      }

      .reveal.is-visible {
        opacity: 1;
        transform: translateY(0);
      }
    }

    /* ─── PAGE HERO ─── */
    .page-hero {
      padding: 100px 7% 56px;
      background: var(--black-soft);
      border-bottom: 1px solid var(--border-gold);
      position: relative;
      overflow: hidden;
        background-image: url("${baseUrl}/vnextimages/companyfiles/teambg.png");
               background-position: center;
               background-size: contain;
               position: relative;
          }

          .page-hero::before {
               content: "";
               position: absolute;
               width: 100%;
               height: 100%;
               top: 0;
               left: 0;
              /*  background: linear-gradient(rgba(10, 10, 10, 0.79), #0a0a0ad1, #111111c7); */
          }

    .hero-eyebrow {
      font-family: var(--font-display);
      font-size: .85rem;
      letter-spacing: .4em;
      text-transform: uppercase;
      color: var(--gold);
      margin-bottom: 1rem;
      display: flex;
      align-items: center;
      gap: 12px;
      font-weight:800;
    }

    .hero-eyebrow::before,
    .hero-eyebrow::after {
      content: '';
      width: 28px;
      height: 1px;
      background: var(--gold);
      opacity: .5;
    }

    .hero-title {
      font-family: var(--font-serif);
      font-size: clamp(2.6rem, 5.5vw, 4.4rem);
      font-weight: 600;
      line-height: 1.08;
      color: var(--white);
      margin-bottom: .5rem;
    }

    .hero-title em {
      color: var(--gold);
      font-style: italic;
    }

    .hero-rule {
      display: flex;
      align-items: center;
      gap: 10px;
      margin: 1rem 0 .8rem;
    }

    .hero-rule-line {
      width: 40px;
      height: 1px;
      background: var(--border-gold-strong);
    }

    .hero-rule-dot {
      width: 4px;
      height: 4px;
      background: var(--gold);
      border-radius: 50%;
    }

    .hero-sub {
      /* font-family: var(--font-serif); */
      font-size: clamp(.95rem, 1.8vw, 1.1rem);
      font-style: italic;
      color: white;
      max-width: 480px;
    }

    /* ─── SECTION DIVIDER ─── */
    .sec-divider {
      height: 1px;
      background: var(--border-gold);
      position: relative;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .sec-divider-inner {
      display: flex;
      align-items: center;
      gap: 10px;
      padding: 0 18px;
      position: absolute;
    }

    .sec-divider-inner.on-dark {
      background: var(--black);
    }

    .sec-divider-inner.on-cream {
      background: var(--cream);
    }

    .sdiv-diamond {
      width: 7px;
      height: 7px;
      border: 1px solid var(--border-gold-strong);
      transform: rotate(45deg);
    }

    .sdiv-label {
      font-family: var(--font-display);
      font-size: .75rem;
      letter-spacing: .28em;
      color: var(--gold);
    }

    .sdiv-label.cream-label {
      color: var(--gold-dark);
    }

    /* ─── PARTNER WRAPPERS ─── */
    .partner-dark {
      background: var(--black-soft);
      color: var(--white);
    }

    .partner-cream {
      background: var(--cream);
      color: #1A1508;
    }

    /* ─── BANNER ─── */
    .pb-banner {
      padding: 44px 20% 36px;
      display: flex;
      align-items: flex-start;
      gap: 50px;
      position: relative;
    }

    .sec-num {
      position: absolute;
      right: 6%;
      top: 16px;
      font-family: var(--font-serif);
      font-size: clamp(5rem, 12vw, 9rem);
      font-weight: 600;
      color: rgba(201, 168, 76, .05);
      pointer-events: none;
      user-select: none;
      line-height: 1;
      z-index: 0;
    }

    .pb-photo {
      flex: 0 0 auto;
      width: clamp(170px, 18vw, 230px);
      position: relative;
      z-index: 1;
    }

    .pb-photo img {
      width: 100%;
      aspect-ratio: 230 / 285;
      height: auto;
      object-fit: cover;
      object-position: top center;
      display: block;
      border: 1px solid var(--border-gold-strong);
      background: var(--black-card);
    }

    .pb-info {
      flex: 1;
      min-width: 0;
      padding-top: 4px;
      position: relative;
      z-index: 1;
    }

    .pb-eyebrow {
      font-family: var(--font-display);
      font-size: .54rem;
      letter-spacing: .28em;
      text-transform: uppercase;
      color: var(--gold);
      margin-bottom: 7px;
    }

    .pb-eyebrow.cream {
      color: var(--gold-dark);
    }

    .pb-name {
      font-family: var(--font-serif);
      font-size: clamp(2rem, 3.8vw, 3rem);
      font-weight: 600;
      line-height: 1.1;
      margin-bottom: 4px;
    }

    .pb-name.dark {
      color: var(--white);
    }

    .pb-name.cream {
      color: #1A1508;
    }

    .pb-rule {
      width: 36px;
      height: 2px;
      background: var(--gold);
      margin: 14px 0;
    }

    .pb-tagline {

      font-size: 1.2rem;

      line-height: 1.75;
      max-width: 440px;
      margin-bottom: 20px;
    }

    .pb-tagline.dark {
      color: var(--gray-1);
    }

    .pb-tagline.cream {
      color: var(--gray-2);
    }

    .pb-badges {
      display: flex;
      gap: var(--gap-xs);
      flex-wrap: wrap;
    }

    .badge {
      display: inline-flex;
      align-items: center;
      gap: 7px;
      padding: 6px 13px;
      border: 1px solid var(--border-gold-strong);
      background: rgba(201, 168, 76, .07);
      transition: background .25s, transform .25s;
    }

    .badge:hover {
      background: rgba(201, 168, 76, .14);
      transform: translateY(-1px);
    }

    .badge span {
      font-family: var(--font-display);
      font-size: .5rem;
      letter-spacing: .12em;
      text-transform: uppercase;
      color: var(--gold);
    }

    .badge.cream-badge {
      background: rgba(201, 168, 76, .1);
      border-color: rgba(139, 105, 20, .4);
    }

    .badge.cream-badge span {
      color: var(--gold-dark);
    }

    .badge svg {
      width: 11px;
      height: 11px;
      stroke: var(--gold);
      fill: none;
      stroke-width: 1.8;
      flex-shrink: 0;
    }

    .badge.cream-badge svg {
      stroke: var(--gold-dark);
    }

    /* ─── ASSOCIATES STRIP ─── */
    .assoc-strip {
      padding: 24px 7% 28px;
      border-top: 1px solid var(--border-gold);
      position: relative;
      z-index: 1;
    }

    .assoc-strip.dark {
      background: var(--black-mid);
    }

    .assoc-strip.cream {
      background: var(--cream-soft);
      border-top-color: rgba(139, 105, 20, .2);
    }

    .assoc-strip-label {
      font-family: var(--font-display);
      font-size: .52rem;
      letter-spacing: .32em;
      text-transform: uppercase;
      margin-bottom: 20px;
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .assoc-strip-label.dark {
      color: var(--gold);
    }

    .assoc-strip-label.dark::after {
      content: '';
      flex: 1;
      height: 1px;
      background: var(--border-gold);
    }

    .assoc-strip-label.cream {
      color: var(--gold-dark);
    }

    .assoc-strip-label.cream::after {
      content: '';
      flex: 1;
      height: 1px;
      background: rgba(139, 105, 20, .25);
    }

    /* Grid layout for associates — equal columns, equal gaps,
       cards stretch evenly to fill the row no matter the count */
    .assoc-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(100px, 1fr));
      gap: var(--gap-lg);
      align-items: start;
    }

    .assoc-card {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 8px;
      max-width: 140px;
      margin: 0 auto;
      transition: transform .3s ease;
      width: 100%;
    }

    .assoc-card:hover {
      transform: translateY(-3px);
    }

    .assoc-card img {
      width: 100%;
      aspect-ratio: 110 / 136;
      object-fit: cover;
      object-position: top;
      border: 1px solid var(--border-gold-strong);
      display: block;
      background: var(--black-card);
    }

    .assoc-name {

      font-size: .99rem;
      font-weight: 500;
      text-align: center;
      line-height: 1.35;
    }

    .assoc-name.dark {
      color: var(--white);
    }

    .assoc-name.cream {
      color: #1A1508;
    }

    .assoc-role {
      font-family: var(--font-serif);
      font-size: .99rem;

      text-align: center;
    }

    .assoc-role.dark {
      color: var(--gold);
    }

    .assoc-role.cream {
      color: var(--gold-dark);
    }

    /* Single associate — horizontal layout */
    .assoc-single {
      display: flex;
      align-items: center;
      gap: var(--gap-lg);
    }

    .assoc-single img {
      width: clamp(100px, 20vw, 150px);

      height: auto;
      object-fit: cover;
      object-position: top;
      border: 1px solid var(--border-gold-strong);
      flex-shrink: 0;
      background: #fff;
    }

    .assoc-single-name {

      font-size: 1.5rem;
      font-weight: 600;
      line-height: 1.3;
      margin-bottom: 3px;
      color: #1A1508;
    }

    .assoc-single-role {

      font-size: .99rem;

      margin-bottom: 8px;
      color: var(--gold-dark);
    }

    .assoc-single-bio {

      font-size: .88rem;
      line-height: 1.7;
    /*   max-width: 540px; */
      color: black;
    }

    /* ─── BODY ─── */
    .pb-body {
      padding: 36px 7% 44px;
      position: relative;
      z-index: 1;
    }

    .pb-body.cream {
      background: var(--cream-soft);
    }

    .two-col {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: var(--gap-md);
      margin-bottom: var(--gap-md);
    }

    .two-col:last-child {
      margin-bottom: 0;
    }

    .three-col {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: var(--gap-md);
      margin-bottom: var(--gap-md);
    }

    /* ─── NEW: Flexible content grid for proper alignment ───
       Use .flex-grid for rows of cards; add .span-full on a
       card that has significantly more content so it takes
       the entire row width (better space utilization). */
    .flex-grid {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: var(--gap-md);
      margin-bottom: var(--gap-md);
      align-items: stretch;
    }

    .flex-grid:last-child {
      margin-bottom: 0;
    }

    .span-full {
      grid-column: 1 / -1;
    }

    @media (max-width: 860px) {
      .flex-grid {
        grid-template-columns: 1fr;
      }
    }

    /* Info cards */
    .icard {
      border: 1px solid var(--border-gold);
      overflow: hidden;
      display: flex;
      flex-direction: column;
    }

    .icard.cream {
      border-color: rgba(139, 105, 20, .3);
      background: #fff;
    }

    .icard-head {
      padding: 10px 18px;
      display: flex;
      align-items: center;
      gap: 9px;
      border-bottom: 1px solid var(--border-gold);
    }

    .icard-head.dark {
      background: rgba(201, 168, 76, .05);
      border-bottom-color: var(--border-gold);
    }

    .icard-head.cream {
      background: rgba(201, 168, 76, .06);
      border-bottom-color: rgba(139, 105, 20, .2);
    }

    .icard-head svg {
      width: 13px;
      height: 13px;
      stroke-width: 1.7;
      fill: none;
      flex-shrink: 0;
      stroke: var(--gold);
    }

    .icard-head.cream svg {
      stroke: var(--gold-dark);
    }

    .icard-title {
      font-family: var(--font-display);
      font-weight:900;

      letter-spacing: .18em;
      text-transform: uppercase;
    }

    .icard-title.dark {
      color: var(--gold-pale);
    }

    .icard-title.cream {
      color: #3A2A0A;
    }

    .icard-body {
      padding: 22px 24px;
      flex: 1;
    }

    /* Body text — slightly larger for better space use */
    .ic-p {

      font-size: 1rem;
      line-height: 1.85;
      margin-bottom: 12px;
    }

    .ic-p:last-child {
      margin-bottom: 0;
    }

    .ic-p.dark {
      color: rgba(250, 250, 248, .72);
    }

    .ic-p.cream {
      color: var(--gray-2);
    }

    .ic-list {
      list-style: none;
    }

    .ic-list li {

      font-size: .96rem;
      padding: 7px 0 7px 16px;
      position: relative;
      border-bottom: 1px solid;
    }

    .ic-list li:last-child {
      border-bottom: none;
    }

    .ic-list li::before {
      content: '◆';
      position: absolute;
      left: 0;
      color: var(--gold);
      font-size: .28rem;
      top: 52%;
      transform: translateY(-50%);
    }

    .ic-list.dark li {
      border-bottom-color: rgba(201, 168, 76, .1);
      color: rgba(250, 250, 248, .75);
    }

    .ic-list.cream li {
      border-bottom-color: rgba(139, 105, 20, .13);
      color: var(--gray-2);
    }

    .ic-list.cream li::before {
      color: var(--gold-dark);
    }

    .ic-sub {
      font-family: var(--font-display);
      font-size: .58rem;
      letter-spacing: .14em;
      text-transform: uppercase;
      display: block;
      margin: 16px 0 8px;
      padding-top: 14px;
      border-top: 1px solid var(--border-gold);
      color: var(--gold);
    }

    .ic-sub.cream {
      color: var(--gold-dark);
      border-top-color: rgba(139, 105, 20, .2);
    }

    /* ─── Two-column list layout inside a span-full card
       (used for Practice Areas + Specialization, etc.) ─── */
    .ic-list-cols {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 0 32px;
    }

    @media (max-width: 640px) {
      .ic-list-cols {
        grid-template-columns: 1fr;
      }
    }

    /* Core cards */
    .core-card {
      border: 1px solid var(--border-gold);
      padding: 0;
      overflow: hidden;
    }

    .core-card.cream {
      border-color: rgba(139, 105, 20, .3);
      background: #fff;
    }

    .core-head {
      padding: 12px 16px;
      display: flex;
      align-items: center;
      gap: 10px;
      border-bottom: 1px solid var(--border-gold);
    }

    .core-head.dark {
      background: rgba(201, 168, 76, .05);
      border-bottom-color: var(--border-gold);
    }

    .core-head.cream {
      background: rgba(201, 168, 76, .06);
      border-bottom-color: rgba(139, 105, 20, .2);
    }

    .core-icon {
      width: 26px;
      height: 26px;
      background: rgba(201, 168, 76, .1);
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
    }

    .core-icon svg {
      width: 12px;
      height: 12px;
      stroke: var(--gold);
      fill: none;
      stroke-width: 1.8;
    }

    .core-icon.cream {
      background: rgba(139, 105, 20, .1);
    }

    .core-icon.cream svg {
      stroke: var(--gold-dark);
    }

    .core-card-title {
      font-family: var(--font-display);
      font-size: .52rem;
      letter-spacing: .1em;
      text-transform: uppercase;
      line-height: 1.4;
    }

    .core-card-title.dark {
      color: var(--gold-pale);
    }

    .core-card-title.cream {
      color: #3A2A0A;
    }

    .core-card ul {
      list-style: none;
      padding: 12px 16px;
    }

    .core-card ul li {
      font-family: var(--font-serif);
      font-size: .87rem;
      padding: 5px 0 5px 11px;
      position: relative;
      border-bottom: 1px solid rgba(201, 168, 76, .08);
    }

    .core-card ul li:last-child {
      border-bottom: none;
    }

    .core-card ul li::before {
      content: '·';
      position: absolute;
      left: 0;
      color: var(--gold);
      font-weight: 700;
    }

    .core-card.dark ul li {
      color: rgba(250, 250, 248, .75);
    }

    .core-card.cream ul li {
      color: var(--gray-2);
    }

    .core-card.cream ul li::before {
      color: var(--gold-dark);
    }

    /* Section heading inline */
    .section-rule {
      display: flex;
      align-items: center;
      gap: 14px;
      margin: 32px 0 18px;
    }

    .section-rule-line {
      flex: 1;
      height: 1px;
      background: var(--border-gold);
    }

    .section-rule-line.cream {
      background: rgba(139, 105, 20, .22);
    }

    .section-rule span {
      font-family: var(--font-display);
      font-size: .54rem;
      letter-spacing: .26em;
      text-transform: uppercase;
      white-space: nowrap;
      color: var(--gold);
    }

    .section-rule span.cream {
      color: var(--gold-dark);
    }

    /* Quote card */
    .quote-card {
      border: 1px solid var(--border-gold);
      padding: 22px 24px;
    }

    .quote-card.cream {
      border-color: rgba(139, 105, 20, .3);
      background: #fff;
    }

    .quote-card p {
      font-family: var(--font-serif);
      font-size: 1rem;
      font-style: italic;
      line-height: 1.8;
    }

    .quote-card.dark p {
      color: rgba(250, 250, 248, .72);
    }

    .quote-card.cream p {
      color: var(--gray-2);
    }

    /* ─── CONTACT CTA ─── */
    .contact-cta {
      background: var(--black-mid);
      border-top: 1px solid var(--border-gold);
      border-bottom: 1px solid var(--border-gold);
      padding: 64px 7%;
      text-align: center;
      position: relative;
      overflow: hidden;
    }

    .contact-cta::after {
      content: '';
      position: absolute;
      inset: 0;
      background: radial-gradient(ellipse at 50% 0%, rgba(201, 168, 76, .06) 0%, transparent 60%);
      pointer-events: none;
    }

    .contact-cta h2 {
      font-family: var(--font-serif);
      font-size: clamp(1.9rem, 3.5vw, 2.8rem);
      font-weight: 600;
      color: var(--white);
      margin-bottom: .5rem;
      position: relative;
    }

    .contact-cta h2 em {
      color: var(--gold);
      font-style: italic;
    }

    .contact-cta>p {
      font-family: var(--font-serif);
      font-size: 1rem;
      font-style: italic;
      color: var(--gray-1);
      margin-bottom: 36px;
      position: relative;
    }

    .cta-cards {
      display: flex;
      gap: var(--gap-sm);
      justify-content: center;
      flex-wrap: wrap;
      margin-bottom: 32px;
      position: relative;
    }

    .cta-card {
      flex: 1 1 220px;
      max-width: 270px;
      background: var(--black-card);
      border: 1px solid var(--border-gold);
      padding: 22px 20px;
      text-align: left;
      transition: border-color .25s, transform .25s;
    }

    .cta-card:hover {
      border-color: var(--border-gold-strong);
      transform: translateY(-3px);
    }

    .cta-card svg {
      width: 18px;
      height: 18px;
      stroke: var(--gold);
      fill: none;
      stroke-width: 1.6;
      margin-bottom: 12px;
      display: block;
    }

    .cta-card-label {
      font-family: var(--font-display);
      font-size: .52rem;
      letter-spacing: .22em;
      text-transform: uppercase;
      color: var(--gold);
      display: block;
      margin-bottom: 7px;
    }

    .cta-card-val {
      font-family: var(--font-serif);
      font-size: .9rem;
      color: var(--white);
      line-height: 1.65;
    }

    .cta-btns {
      display: flex;
      gap: 12px;
      justify-content: center;
      flex-wrap: wrap;
      position: relative;
    }

    .btn-gold {
      font-family: var(--font-display);
      font-size: .58rem;
      letter-spacing: .16em;
      text-transform: uppercase;
      padding: 13px 30px;
      background: var(--gold);
      color: var(--black);
      border: none;
      cursor: pointer;
      text-decoration: none;
      display: inline-block;
      transition: background .25s, transform .2s;
    }

    .btn-gold:hover {
      background: var(--gold-light);
      transform: translateY(-1px);
    }

    .btn-outline-gold {
      font-family: var(--font-display);
      font-size: .58rem;
      letter-spacing: .16em;
      text-transform: uppercase;
      padding: 12px 28px;
      background: transparent;
      color: var(--gold);
      border: 1px solid var(--gold);
      cursor: pointer;
      text-decoration: none;
      display: inline-block;
      transition: all .25s;
    }

    .btn-outline-gold:hover {
      background: rgba(201, 168, 76, .1);
    }

    /* ─── JOIN BLOCK ─── */
    .join-block {
      background: var(--cream);
      padding: 72px 7%;
      position: relative;
      overflow: hidden;
      border-top: 1px solid rgba(139, 105, 20, .3);
    }

    .join-block::after {
      content: '04';
      position: absolute;
      right: 5%;
      top: 50%;
      transform: translateY(-50%);
      font-family: var(--font-serif);
      font-size: clamp(5rem, 14vw, 10rem);
      font-weight: 600;
      color: rgba(139, 105, 20, .05);
      pointer-events: none;
      line-height: 1;
    }

    .join-inner {
      max-width: 640px;
      position: relative;
    }

    .join-eyebrow {
      font-family: var(--font-display);
      font-size: .54rem;
      letter-spacing: .32em;
      text-transform: uppercase;
      color: var(--gold-dark);
      margin-bottom: 12px;
    }

    .join-title {
      font-family: var(--font-serif);
      font-size: clamp(1.9rem, 3.5vw, 2.8rem);
      font-weight: 600;
      color: #1A1508;
      margin-bottom: 4px;
    }

    .join-rule {
      width: 36px;
      height: 2px;
      background: var(--gold);
      margin: 14px 0;
    }

    .join-sub {
      font-family: var(--font-serif);
      font-size: 1rem;
      font-style: italic;
      color: var(--gray-2);
      line-height: 1.78;
      margin-bottom: 30px;
    }

    .join-cards {
      display: flex;
      gap: var(--gap-sm);
      flex-wrap: wrap;
      margin-bottom: 28px;
    }

    .join-card {
      flex: 1 1 180px;
      background: #fff;
      border: 1px solid rgba(139, 105, 20, .3);
      padding: 16px 18px;
      transition: transform .25s, border-color .25s;
    }

    .join-card:hover {
      transform: translateY(-2px);
      border-color: rgba(139, 105, 20, .5);
    }

    .join-card svg {
      width: 16px;
      height: 16px;
      stroke: var(--gold-dark);
      fill: none;
      stroke-width: 1.7;
      margin-bottom: 8px;
      display: block;
    }

    .join-card-label {
      font-family: var(--font-display);
      font-size: .5rem;
      letter-spacing: .18em;
      text-transform: uppercase;
      color: var(--gold-dark);
      margin-bottom: 4px;
    }

    .join-card p {
      font-family: var(--font-serif);
      font-size: .88rem;
      color: var(--gray-2);
      line-height: 1.65;
    }

    /* ─── FOOTER ─── */
    footer {
      background: var(--black);
      border-top: 1px solid var(--border-gold);
      padding: 48px 7% 24px;
    }

    .footer-inner {
      display: flex;
      gap: 40px;
      flex-wrap: wrap;
      padding-bottom: 28px;
      border-bottom: 1px solid rgba(201, 168, 76, .1);
      max-width: 1200px;
      margin: 0 auto;
    }

    .footer-brand {
      flex: 2 1 220px;
    }

    .footer-brand-name {
      font-family: var(--font-display);
      font-size: 1rem;
      letter-spacing: .14em;
      color: var(--gold);
      display: block;
    }

    .footer-brand-sub {
      font-family: var(--font-body);
      font-size: .5rem;
      letter-spacing: .28em;
      text-transform: uppercase;
      color: rgba(250, 250, 248, .2);
      display: block;
      margin: 4px 0 10px;
    }

    .footer-brand-desc {
      font-family: var(--font-serif);
      font-size: .87rem;
      font-style: italic;
      line-height: 1.75;
      color: rgba(250, 250, 248, .35);
      max-width: 360px;
    }

    .footer-col {
      flex: 1 1 110px;
    }

    .footer-col-title {
      font-family: var(--font-display);
      font-size: .5rem;
      letter-spacing: .3em;
      text-transform: uppercase;
      color: var(--gold);
      margin-bottom: 14px;
    }

    .footer-links {
      list-style: none;
      display: flex;
      flex-direction: column;
      gap: 9px;
    }

    .footer-links a {
      font-family: var(--font-serif);
      font-size: .88rem;
      color: rgba(250, 250, 248, .38);
      text-decoration: none;
      transition: color .25s;
    }

    .footer-links a:hover {
      color: var(--gold);
    }

    .footer-bottom {
      max-width: 1200px;
      margin: 18px auto 0;
      display: flex;
      justify-content: space-between;
      flex-wrap: wrap;
      gap: 8px;
    }

    .footer-copy {
      font-family: var(--font-body);
      font-size: .52rem;
      letter-spacing: .14em;
      color: rgba(250, 250, 248, .2);
    }

    /* WhatsApp float */
    .wa-float {
      position: fixed;
      bottom: 24px;
      right: 24px;
      z-index: 500;
      width: 48px;
      height: 48px;
      background: #25D366;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 4px 18px rgba(37, 211, 102, .35);
      text-decoration: none;
      transition: transform .3s;
    }

    .wa-float:hover {
      transform: scale(1.1) translateY(-2px);
    }

    .wa-float svg {
      width: 24px;
      height: 24px;
      fill: #fff;
    }

    /* ─── ACCESSIBILITY ─── */
    a:focus-visible,
    button:focus-visible {
      outline: 2px solid var(--gold);
      outline-offset: 2px;
    }

    /* ─── RESPONSIVE ─── */
    @media(max-width: 860px) {

      .two-col,
      .three-col {
        grid-template-columns: 1fr;
      }

      .pb-banner {
        flex-direction: column;
        gap: var(--gap-md);
      }

      .pb-photo {
        width: clamp(160px, 50vw, 210px);
        align-self: center;
      }

      .sec-num {
        font-size: 5rem;
        top: 10px;
      }

      .assoc-single {
        flex-direction: column;
        text-align: center;
      }

      .assoc-single img {
        width: clamp(120px, 40vw, 160px);
      }

      .assoc-single-bio {
        max-width: 100%;
      }

      .footer-bottom {
        flex-direction: column;
        text-align: center;
      }
    }

    @media(max-width: 520px) {
      .page-hero {
        padding: 80px 6% 44px;
      }

      .pb-banner,
      .assoc-strip,
      .pb-body,
      .join-block,
      .contact-cta {
        padding-left: 6%;
        padding-right: 6%;
      }

      .assoc-grid {
        grid-template-columns: repeat(auto-fit, minmax(80px, 1fr));
        gap: var(--gap-sm);
      }

      .assoc-card {
        max-width: 110px;
      }

      .cta-card {
        max-width: 100%;
        flex: 1 1 100%;
      }

      .badge {
        padding: 5px 11px;
      }
    }
  </style>
</head>

<body>

 <%@ include file="header.jsp" %>

  <!-- PAGE HERO -->
  <section class="page-hero">
    <div class="hero-eyebrow">Our Team &amp; Leadership</div>
    <h1 class="hero-title">The Minds Behind<br><em>Every Victory</em></h1>
    <div class="hero-rule">
      <div class="hero-rule-line"></div>
      <div class="hero-rule-dot"></div>
      <div class="hero-rule-line"></div>
    </div>
    <p class="hero-sub">Three decades of combined practice — advocates, tax strategists, and labour specialists united
      under one firm.</p>
  </section>


  <!-- ══════════════════════
  PARTNER 01 — ADV. VIJAY SHARMA (DARK)
══════════════════════ -->
  <div class="partner-dark" id="s1">

    <div class="pb-banner reveal">
      <div class="sec-num">01</div>
      <div class="pb-photo">
        <img src="${baseUrl}/vnextimages/companyfiles/team/4.jpeg" alt="Adv. Vijay Sharma">
      </div>
      <div class="pb-info">
        <div class="pb-eyebrow">Partner · VNext Legal LLP</div>
        <h2 class="pb-name dark">Adv. Vijay Sharma</h2>
        <div class="pb-rule"></div>
        <p class="pb-tagline dark">Over 30 years delivering strategic, result-driven legal solutions across India's
          premier courts and tribunals.</p>
        <div class="pb-badges">
          <div class="badge"><svg viewBox="0 0 24 24">
              <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
            </svg><span>Corporate Law</span></div>
          <div class="badge"><svg viewBox="0 0 24 24">
              <polyline points="22 12 18 12 15 21 9 3 6 12 2 12" />
            </svg><span>Arbitration</span></div>
          <div class="badge"><svg viewBox="0 0 24 24">
              <rect x="3" y="11" width="18" height="11" rx="2" />
              <path d="M7 11V7a5 5 0 0 1 10 0v4" />
            </svg><span>IBC / Insolvency</span></div>
        </div>
      </div>
    </div>

    <!-- Associates strip -->
    <div class="assoc-strip dark reveal">
      <div class="assoc-strip-label dark">Associates</div>
      <div class="assoc-grid">
        <div class="assoc-card">
          <img src="${baseUrl}/vnextimages/companyfiles/team/1.jpeg" alt="Adv. Swagoti Batchas">
          <div class="assoc-name dark">Adv. Swagoti Batchas</div>
          <div class="assoc-role dark">Associate</div>
        </div>
        <div class="assoc-card">
          <img src="${baseUrl}/vnextimages/companyfiles/team/10.jpeg" alt="Adv. Mohlan Sonowal">
          <div class="assoc-name dark">Adv. Mohlan Sonowal</div>
          <div class="assoc-role dark">Associate</div>
        </div>
        <div class="assoc-card">
          <img src="${baseUrl}/vnextimages/companyfiles/team/9.jpeg" alt="Adv. Megha Rani">
          <div class="assoc-name dark">Adv. Megha Rani</div>
          <div class="assoc-role dark">Associate</div>
        </div>
        <div class="assoc-card">
          <img src="${baseUrl}/vnextimages/companyfiles/team/8.jpeg" alt="Adv. Shakti Chaturvedi">
          <div class="assoc-name dark">Adv. Shakti Chaturvedi</div>
          <div class="assoc-role dark">Associate</div>
        </div>
        <div class="assoc-card">
          <img src="${baseUrl}/vnextimages/companyfiles/team/7.jpeg" alt="Adv. Deepshikha Bisht">
          <div class="assoc-name dark">Adv. Deepshikha Bisht</div>
          <div class="assoc-role dark">Associate</div>
        </div>
      </div>
    </div>

    <div class="pb-body reveal">

      <!-- Profile — spans full row (most content) -->
      <div class="flex-grid">
        <div class="icard span-full">
          <div class="icard-head dark">
            <svg viewBox="0 0 24 24">
              <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
              <circle cx="12" cy="7" r="4" />
            </svg>
            <div class="icard-title dark">Profile</div>
          </div>
          <div class="icard-body">
            <p class="ic-p dark">Leading a team of skilled professionals, Adv. Sharma advises a diverse clientele —
              domestic and international companies, banks, financial institutions, government bodies, NGOs, and PSUs —
              with over 30 years of practice before judicial and quasi-judicial forums.</p>
            <p class="ic-p dark">He was appointed Counsel for DTC at Delhi High Court (2000–2007), Special Counsel for
              NDMC, SDMC (2016–17), Legal Aid Committee Delhi HC (2003–05), and Counsel for DGMAP (2021–23, reappointed
              Feb 2026).</p>
            <p class="ic-p dark">Adv. Sharma has handled arbitrations before retired Judges including Justice Kailash
              Gambhir, Justice KG Balakrishnan, Justice Anil Dave, Justice Swatanter Kumar, and Justice B S Chauhan,
              among others.</p>
            <p class="ic-p dark">He primarily appears before the Supreme Court of India, various High Courts, NCLT
              Tribunals (Delhi, Bombay, Calcutta, Allahabad), National Green Tribunal, DRT, DRAT, and NCDRC.</p>
          </div>
        </div>
      </div>

      <!-- Practice Areas + Empanelment — equal side by side -->
      <div class="flex-grid">
        <div class="icard">
          <div class="icard-head dark">
            <svg viewBox="0 0 24 24">
              <rect x="3" y="3" width="18" height="18" rx="2" />
              <path d="M3 9h18M9 21V9" />
            </svg>
            <div class="icard-title dark">Practice Areas</div>
          </div>
          <div class="icard-body">
            <ul class="ic-list dark">
              <li>Corporate, Business &amp; Commercial Law (Pan India NCLT &amp; NCLAT)</li>
              <li>Domestic &amp; International Arbitration &amp; Litigation</li>
              <li>Insolvency &amp; Bankruptcy (IBC)</li>
              <li>Civil &amp; Commercial Litigation</li>
              <li>Criminal Litigation (White Collar)</li>
              <li>Environmental Litigation (National Green Tribunal)</li>
              <li>Medico-Legal Cases — Consumer Commissions</li>
              <li>Property Disputes · DRT · DRAT</li>
              <li>Prevention of Money Laundering Matters</li>
              <li>CBI &amp; Enforcement Directorate (ED)</li>
              <li>Negotiable Instrument Act · MSME Matters</li>
            </ul>
          </div>
        </div>
        <div class="icard">
          <div class="icard-head dark">
            <svg viewBox="0 0 24 24">
              <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" />
              <polyline points="9 22 9 12 15 12 15 22" />
            </svg>
            <div class="icard-title dark">Major Clients &amp; Empanelment</div>
          </div>
          <div class="icard-body">
            <ul class="ic-list dark">
              <li>NEDFI · Kotak Mahindra Bank · NRL</li>
              <li>Assam Gas Company Limited (AGCL)</li>
              <li>NBCC · Ministry of Defence (DGMAP)</li>
              <li>Max Healthcare Institute (PAN MAX)</li>
              <li>Artemis Hospital, Gurgaon</li>
              <li>South Delhi Municipal Corporation — Delhi HC</li>
              <li>AWHO</li>
            </ul>
          </div>
        </div>
      </div>

    </div>

  </div><!-- /partner 01 -->


  <!-- DIVIDER -->
  <div class="sec-divider">
    <div class="sec-divider-inner on-cream">
      <div class="sdiv-diamond"></div>
      <span class="sdiv-label cream-label">02</span>
      <div class="sdiv-diamond"></div>
    </div>
  </div>





  <!-- DIVIDER -->
  <div class="sec-divider">
    <div class="sec-divider-inner on-dark">
      <div class="sdiv-diamond"></div>
      <span class="sdiv-label">03</span>
      <div class="sdiv-diamond"></div>
    </div>
  </div>


  <!-- ══════════════════════
  PARTNER 03 — ADV. RAMESH KUMAR (DARK)
══════════════════════ -->
  <div class="partner-dark" id="s3">

    <div class="pb-banner reveal">
      <div class="sec-num"></div>
      <div class="pb-photo">
        <img src="${baseUrl}/vnextimages/companyfiles/team/6.jpeg" alt="Adv. Ramesh Kumar">
      </div>
      <div class="pb-info">
        <div class="pb-eyebrow">Partner · VNext Legal LLP</div>
        <h2 class="pb-name dark">Adv. Ramesh Kumar</h2>
        <div class="pb-rule"></div>
        <p class="pb-tagline dark">A seasoned taxation and compliance specialist with 30+ years guiding individuals,
          startups, and corporates through India's evolving regulatory landscape.</p>
        <div class="pb-badges">
          <div class="badge"><svg viewBox="0 0 24 24">
              <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
            </svg><span>Advocate</span></div>
          <div class="badge"><svg viewBox="0 0 24 24">
              <polyline points="22 12 18 12 15 21 9 3 6 12 2 12" />
            </svg><span>Tax Consultant</span></div>
          <div class="badge"><svg viewBox="0 0 24 24">
              <rect x="3" y="11" width="18" height="11" rx="2" />
              <path d="M7 11V7a5 5 0 0 1 10 0v4" />
            </svg><span>Regulatory Compliance</span></div>
        </div>
      </div>
    </div>

    <!-- Associates strip -->
    <div class="assoc-strip dark reveal">
      <div class="assoc-strip-label dark">Associates</div>
      <div class="assoc-grid">
        <div class="assoc-card">
          <img src="${baseUrl}/vnextimages/companyfiles/team/5.jpeg" alt="Adv. Rajnish Kumar">
          <div class="assoc-name dark">Adv. Rajnish Kumar</div>
          <div class="assoc-role dark">Associate</div>
        </div>
        <div class="assoc-card">
          <img src="${baseUrl}/vnextimages/companyfiles/team/13.jpeg" alt="Adv. Shailesh Kumar">
          <div class="assoc-name dark">Adv. Shailesh Kumar</div>
          <div class="assoc-role dark">Associate</div>
        </div>
        <div class="assoc-card">
          <img src="${baseUrl}/vnextimages/companyfiles/team/12.jpeg" alt="Adv. Himanshu Gautam">
          <div class="assoc-name dark">Adv. Himanshu Gautam</div>
          <div class="assoc-role dark">Associate</div>
        </div>
        <div class="assoc-card">
          <img src="${baseUrl}/vnextimages/companyfiles/team/11.jpeg" alt="Adv. Shanker Singh">
          <div class="assoc-name dark">Adv. Shanker Singh</div>
          <div class="assoc-role dark">Associate</div>
        </div>
      </div>
    </div>

    <div class="pb-body reveal">

      <!-- Profile — full width -->
      <div class="flex-grid">
        <div class="icard span-full">
          <div class="icard-head dark">
            <svg viewBox="0 0 24 24">
              <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
              <circle cx="12" cy="7" r="4" />
            </svg>
            <div class="icard-title dark">Profile</div>
          </div>
          <div class="icard-body">
            <p class="ic-p dark">Adv. Ramesh Kumar brings 30+ years of specialist expertise in Direct and Indirect
              Taxation — providing advisory, assessment proceedings, reassessment cases, and strategic tax planning to a
              broad clientele.</p>
            <p class="ic-p dark">In the GST space, he handles advisory, litigation, departmental audits, appeals, and
              compliance management with precision. He also advises startups and emerging businesses at every stage of
              their growth.</p>
            <p class="ic-p dark">He actively handles Foreign Trade Policy (FTP), import-export compliance, and
              regulatory advisory for cross-border trade operations.</p>
          </div>
        </div>
      </div>

      <!-- Practice Areas — full width, two-column list -->
      <div class="flex-grid">
        <div class="icard span-full">
          <div class="icard-head dark">
            <svg viewBox="0 0 24 24">
              <rect x="3" y="3" width="18" height="18" rx="2" />
              <path d="M3 9h18M9 21V9" />
            </svg>
            <div class="icard-title dark">Practice Areas</div>
          </div>
          <div class="icard-body">
            <div class="ic-list-cols">
              <ul class="ic-list dark">
                <li>Direct Taxes &amp; Income Tax Advisory</li>
                <li>Goods and Services Tax (GST)</li>
                <li>Customs, Excise &amp; Service Tax</li>
                <li>Appeals &amp; Litigation Support</li>
                <li>Foreign Trade Policy (FTP)</li>
                <li>Tax Planning &amp; Structuring</li>
              </ul>
              <ul class="ic-list dark">
                <li>Re-assessments &amp; Proceedings</li>
                <li>Startup Advisory</li>
                <li>Corporate &amp; MCA Compliance</li>
                <li>EPFO &amp; Labour Law Matters</li>
                <li>MSME &amp; Business Registration</li>
                <li>SARFAESI &amp; Financial Advisory</li>
              </ul>
            </div>
          </div>
        </div>
      </div>

      <!-- Core 3-col -->
      <div class="section-rule">
        <div class="section-rule-line"></div>
        <span>Core Practice Areas</span>
        <div class="section-rule-line"></div>
      </div>
      <div class="three-col">
        <div class="core-card dark">
          <div class="core-head dark">
            <div class="core-icon"><svg viewBox="0 0 24 24">
                <circle cx="12" cy="12" r="10" />
                <path d="M12 8v4l3 3" />
              </svg></div>
            <div class="core-card-title dark">Direct Taxation (Income Tax)</div>
          </div>
          <ul>
            <li>ITR Filing &amp; Tax Advisory</li>
            <li>Assessments &amp; Scrutiny</li>
            <li>TDS Compliance &amp; Return Filing</li>
            <li>Income Tax Notices &amp; Representation</li>
            <li>Appeals &amp; Litigation</li>
          </ul>
        </div>
        <div class="core-card dark">
          <div class="core-head dark">
            <div class="core-icon"><svg viewBox="0 0 24 24">
                <path
                  d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
              </svg></div>
            <div class="core-card-title dark">Goods &amp; Services Tax</div>
          </div>
          <ul>
            <li>GST Registration &amp; Amendments</li>
            <li>Return Filing &amp; Annual Returns</li>
            <li>GST Audit &amp; Refund Claims</li>
            <li>Departmental Proceedings</li>
            <li>Input Tax Credit (ITC) Advisory</li>
          </ul>
        </div>
        <div class="core-card dark">
          <div class="core-head dark">
            <div class="core-icon"><svg viewBox="0 0 24 24">
                <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" />
              </svg></div>
            <div class="core-card-title dark">Corporate &amp; MCA Compliance</div>
          </div>
          <ul>
            <li>Company &amp; LLP Registration</li>
            <li>ROC Annual Filing</li>
            <li>Director KYC &amp; DIN/DSC</li>
            <li>Corporate Governance</li>
            <li>Startup Registration</li>
          </ul>
        </div>
      </div>

      <!-- Memberships + Philosophy — balanced pair -->
      <div class="flex-grid">
        <div class="icard">
          <div class="icard-head dark">
            <svg viewBox="0 0 24 24">
              <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
              <circle cx="9" cy="7" r="4" />
              <path d="M23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75" />
            </svg>
            <div class="icard-title dark">Professional Memberships</div>
          </div>
          <div class="icard-body">
            <ul class="ic-list dark">
              <li>District Tax Bar Association (Regd.), Faridabad</li>
              <li>Faridabad Income Tax Bar Association (Regd.)</li>
              <li>Sales Tax Bar Association, Lucknow</li>
              <li>Lucknow Bar Association</li>
            </ul>
          </div>
        </div>
        <div class="icard">
          <div class="icard-head dark">
            <svg viewBox="0 0 24 24">
              <circle cx="12" cy="12" r="10" />
              <path d="M12 8v4M12 16h.01" />
            </svg>
            <div class="icard-title dark">Professional Philosophy</div>
          </div>
          <div class="icard-body" style="display:flex;align-items:center;height:100%;">
            <p class="ic-p dark" style="margin-bottom:0;font-style:italic">"Success in taxation is not merely about
              meeting statutory requirements — it is about building a strong legal foundation for sustainable growth and
              long-term business success."</p>
          </div>
        </div>
      </div>

    </div>

  </div><!-- /partner 03 -->




  <!-- DIVIDER -->
  <div class="sec-divider">
    <div class="sec-divider-inner on-dark">
      <div class="sdiv-diamond"></div>
      <span class="sdiv-label">·</span>
      <div class="sdiv-diamond"></div>
    </div>
  </div>


  <!-- DIVIDER -->
    <div class="sec-divider">
      <div class="sec-divider-inner on-dark">
        <div class="sdiv-diamond"></div>
        <span class="sdiv-label">04</span>
        <div class="sdiv-diamond"></div>
      </div>
    </div>

    <!-- ══════════════════════
    PARTNER 04 — ADV. RAMESH KUMAR (LABOUR SPECIALIST) (DARK)
  ══════════════════════ -->
    <div class="partner-dark" id="s4">

      <div class="pb-banner reveal">
        <div class="sec-num">04</div>
        <div class="pb-photo">
          <!-- Make sure to update the image name below with the actual file uploaded to your server -->
          <img src="${baseUrl}/vnextimages/companyfiles/team/ramesh_kumar_associate.jpeg" alt="Adv. Ramesh Kumar">
        </div>
        <div class="pb-info">
          <div class="pb-eyebrow">Associate Partner · VNext Legal LLP</div>
          <h2 class="pb-name dark">Adv. Ramesh Kumar</h2>
          <div class="pb-rule"></div>
          <p class="pb-tagline dark">A seasoned Labour and Industrial Laws specialist, with 45+ years of experience. Also Expertise in MSME (Respondent Side). CONSUMER FORUM, CIVIL AND CRIMINAL LAWS, MATRIMONIAL CASES, etc.</p>
          <div class="pb-badges">
            <div class="badge">
              <svg viewBox="0 0 24 24">
                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
              </svg>
              <span>Labour &amp; Industrial Law</span>
            </div>
            <div class="badge">
              <svg viewBox="0 0 24 24">
                <rect x="3" y="11" width="18" height="11" rx="2" />
                <path d="M7 11V7a5 5 0 0 1 10 0v4" />
              </svg>
              <span>MSME (Respondent)</span>
            </div>
            <div class="badge">
              <svg viewBox="0 0 24 24">
                <polyline points="22 12 18 12 15 21 9 3 6 12 2 12" />
              </svg>
              <span>Dispute Resolution (Consumer, Civil, Criminal, Matrimonial)</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Associates strip -->
      <div class="assoc-strip dark reveal">
        <div class="assoc-strip-label dark">Associates</div>
        <div class="assoc-grid">
          <div class="assoc-card">
            <!-- Update image src -->
            <img src="${baseUrl}/vnextimages/companyfiles/team/vishnu_gupta.jpeg" alt="Adv. Vishnu Gupta">
            <div class="assoc-name dark">Adv. Vishnu Gupta</div>
            <div class="assoc-role dark">Associate Advocate</div>
          </div>
          <div class="assoc-card">
            <!-- Update image src -->
            <img src="${baseUrl}/vnextimages/companyfiles/team/ritu_garg.jpeg" alt="Adv. Ritu Garg">
            <div class="assoc-name dark">Adv. Ritu Garg</div>
            <div class="assoc-role dark">Associate Advocate</div>
          </div>
          <div class="assoc-card">
            <!-- Update image src -->
            <img src="${baseUrl}/vnextimages/companyfiles/team/harpreet_kaur.jpeg" alt="Adv. Harpreet Kaur">
            <div class="assoc-name dark">Adv. Harpreet Kaur</div>
            <div class="assoc-role dark">Associate Advocate</div>
          </div>
        </div>
      </div>

    </div><!-- /partner 04 -->



   <%@ include file="footer.jsp" %>


  <script>
    if (window.matchMedia('(prefers-reduced-motion: no-preference)').matches) {
      const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            entry.target.classList.add('is-visible');
            observer.unobserve(entry.target);
          }
        });
      }, { threshold: 0.12, rootMargin: '0px 0px -60px 0px' });

      document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
    } else {
      document.querySelectorAll('.reveal').forEach(el => el.classList.add('is-visible'));
    }
  </script>

</body>

</html>