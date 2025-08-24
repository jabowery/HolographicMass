(* ::Package:: *)

ToSub[varEqExpression_]:=varEqExpression[[1]]->varEqExpression[[2]]
ToEqual[sub_]:=sub[[1]]==sub[[2]]
SubToEqSub[sub_]:=sub[[1]]->ToEqual[sub]
codata[canonicalName_]:= Around@@Entity["PhysicalConstant",canonicalName][{"Value","StandardUncertainty"}]
physicalConstants = {
\[Alpha]->codata["FineStructureConstant"],
c->codata["SpeedOfLight"],
h->codata["PlanckConstant"],
me->codata["ElectronMass"],
mp->codata["ProtonMass"],
rp->codata["ProtonRMSChargeRadius"],
RH->codata["RydbergConstantHydrogen"](*Rydberg costant with \[Mu]e *),
\[HBar]->codata["ReducedPlanckConstant"],
h->codata["PlanckConstant"],
a0->codata["BohrRadius"],
\[Epsilon]0->codata["ElectricConstant"],
\[Mu]0->codata["MagneticConstant"],
e->codata["ElementaryCharge"],
PlanckLength->codata["PlanckLength"],
PlanckMass -> codata["PlanckMass"]}
physicalConstants = Join[{\[Mu]e->(me mp/(me+mp))(* reduced electron mass *),aH->\[Alpha]/(4 Pi R)(* hydrogen radius *)}/.physicalConstants,physicalConstants]
physicalConstantExpressions = {
\[Alpha]->\[Mu]0 e^2 c/(2 \[HBar] 2 Pi),
a0-> \[Alpha]/(4 Pi Rme),
aH -> \[Alpha]/(4 Pi R\[Mu]e),
Rme->\[Alpha] e^2 me/(16 \[Epsilon]0 \[HBar]^2 Pi^2),
R\[Mu]e -> R,
R->\[Alpha] e^2 \[Mu]e/(16 \[Epsilon]0 \[HBar]^2 Pi^2),
\[Mu]B->e \[HBar]/(2 me) ,
\[Mu]e->(me mp/(me+mp)),
me0->(4 \[Pi] \[Epsilon]0 \[HBar]^2)/(a0 e^2),
\[Mu]0->1/(c^2 \[Epsilon]0),
PlanckLength->Sqrt[\[HBar] G/c^3],
PlanckMass->Sqrt[\[HBar] c/G]
}
PhysicsDefinitions = SubToEqSub/@physicalConstantExpressions (* for use in Eliminate *)
RHSphysicalConstants[eq_]:=First[eq]==(eq[[2]]/.physicalConstants)
RelativeError[theoretic_,measured_]:=1-theoretic/measured
BlackholeRadius[mass_]:=2 G mass/c^2
BlackholeMass[radius_]:=Solve[radius==BlackholeRadius[mass],mass][[1,1,2]]
SphereVolume[r_]:=4/3 Pi r^3
CircleArea[r_]:=Pi r^2
SphereArea[r_]:=4CircleArea[r]






