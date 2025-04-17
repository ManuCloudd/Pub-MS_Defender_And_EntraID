### EmailOps/Import-Forwarding-V2.ps1
 # 🌟 Présentation du dépôt 🌟
 
 **Objectif**  
 Transférer la réception des boîtes aux lettres selon un CSV, puis exporter un rapport.
 
 **Fonctionnalités**  
 - Lit un CSV (`Upn`, `ForwardTo`).  
 - Active `DeliverToMailboxAndForward` et configure `ForwardingSMTPAddress`.  
 - Gère Exchange on‑prem (SnapIn) ou Exchange Online.  
 - Journalise chaque action et gère les erreurs.  
 - Exporte un rapport des boîtes ayant le forwarding activé.