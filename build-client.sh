#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(pwd)"
ARCHIVE="$ROOT_DIR/.render-source/client-source.tar.xz"

if [[ ! -d "$ROOT_DIR/.render-source" ]]; then
  echo "Source archive is missing: .render-source/" >&2
  exit 1
fi

cat "$ROOT_DIR"/.render-source/part-* | base64 --decode > "$ARCHIVE"
tar -tJf "$ARCHIVE" >/dev/null
tar -xJf "$ARCHIVE" -C "$ROOT_DIR"

cd "$ROOT_DIR/client"

# Keep the navigation item IDs literal-typed for the Page union.
node <<'NODE'
const fs = require('node:fs');
const file = 'src/App.tsx';
const source = fs.readFileSync(file, 'utf8');

const oldBlock = [
  "const navFor = (roles:string[], space:'backoffice'|'citizen'|'agent'):{id:Page;label:string;icon:LucideIcon;roles?:string[]}[] => {",
  "  if(space==='citizen')return [{id:'dashboard',label:'Accueil',icon:Home},{id:'reports',label:'Mes signalements',icon:ClipboardCheck},{id:'new-report',label:'Signaler',icon:Camera},{id:'profile',label:'Profil',icon:Users}];",
  "  if(space==='agent')return [{id:'missions',label:'Mes missions',icon:Truck},{id:'map',label:'Carte',icon:Map},{id:'profile',label:'Profil',icon:Users}];",
  "  return [",
  "    {id:'dashboard',label:'Tableau de bord',icon:Grid2X2},",
  "    {id:'qualification',label:'Qualification',icon:ClipboardCheck,roles:['AGENT_QUALIFICATION']},",
  "    {id:'cases',label:'Dossiers',icon:FileImage,roles:['RESPONSABLE_TRAITEMENT']},",
  "    {id:'assignments',label:'Affectations',icon:Users,roles:['RESPONSABLE_AFFECTATION']},",
  "    {id:'interventions',label:'Interventions',icon:Truck,roles:['AGENT_TERRAIN']},",
  "    {id:'verification',label:'Vérification',icon:ShieldCheck,roles:['VERIFICATEUR_CLOTURE']},",
  "    {id:'referentials',label:'Référentiels',icon:Recycle,roles:['GESTIONNAIRE_REFERENTIEL']},",
  "    {id:'accounts',label:'Comptes',icon:Users,roles:['ADMINISTRATEUR_COMPTES']},",
  "  ].filter(x=>!x.roles||x.roles.some(r=>roles.includes(r)));",
  "};"
].join('\n');

const newBlock = [
  "type NavItem = { id: Page; label: string; icon: LucideIcon; roles?: string[] };",
  "const navFor = (roles: string[], space: 'backoffice'|'citizen'|'agent'): NavItem[] => {",
  "  if (space === 'citizen') return [",
  "    { id: 'dashboard', label: 'Accueil', icon: Home },",
  "    { id: 'reports', label: 'Mes signalements', icon: ClipboardCheck },",
  "    { id: 'new-report', label: 'Signaler', icon: Camera },",
  "    { id: 'profile', label: 'Profil', icon: Users },",
  "  ];",
  "  if (space === 'agent') return [",
  "    { id: 'missions', label: 'Mes missions', icon: Truck },",
  "    { id: 'map', label: 'Carte', icon: Map },",
  "    { id: 'profile', label: 'Profil', icon: Users },",
  "  ];",
  "  const items: NavItem[] = [",
  "    { id: 'dashboard', label: 'Tableau de bord', icon: Grid2X2 },",
  "    { id: 'qualification', label: 'Qualification', icon: ClipboardCheck, roles: ['AGENT_QUALIFICATION'] },",
  "    { id: 'cases', label: 'Dossiers', icon: FileImage, roles: ['RESPONSABLE_TRAITEMENT'] },",
  "    { id: 'assignments', label: 'Affectations', icon: Users, roles: ['RESPONSABLE_AFFECTATION'] },",
  "    { id: 'interventions', label: 'Interventions', icon: Truck, roles: ['AGENT_TERRAIN'] },",
  "    { id: 'verification', label: 'Vérification', icon: ShieldCheck, roles: ['VERIFICATEUR_CLOTURE'] },",
  "    { id: 'referentials', label: 'Référentiels', icon: Recycle, roles: ['GESTIONNAIRE_REFERENTIEL'] },",
  "    { id: 'accounts', label: 'Comptes', icon: Users, roles: ['ADMINISTRATEUR_COMPTES'] },",
  "  ];",
  "  return items.filter(item => !item.roles || item.roles.some(role => roles.includes(role)));",
  "};"
].join('\n');

if (source.includes(oldBlock)) {
  fs.writeFileSync(file, source.replace(oldBlock, newBlock));
} else if (!source.includes('type NavItem = { id: Page; label: string; icon: LucideIcon; roles?: string[] };')) {
  throw new Error('Expected navigation block was not found; refusing an unsafe source rewrite.');
}
NODE

npm install --include=dev --no-audit --no-fund
npm run build
