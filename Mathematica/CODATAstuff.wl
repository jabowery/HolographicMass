(* ::Package:: *)

(* ::Package:: *)

(* Helper functions *)
ToSub[varEqExpression_]:=varEqExpression[[1]]->varEqExpression[[2]]
ToEqual[sub_]:=sub[[1]]==sub[[2]]
SubToEqSub[sub_]:=sub[[1]]->ToEqual[sub]

(* CODATA access function *)
codata[canonicalName_]:= Around@@Entity["PhysicalConstant",canonicalName][{"Value","StandardUncertainty"}]

(* Physical constants with proper error handling *)
physicalConstants = {
  \[Alpha] -> codata["FineStructureConstant"],
  c -> codata["SpeedOfLight"],
  h -> codata["PlanckConstant"],
  \[HBar] -> codata["ReducedPlanckConstant"],
  me -> codata["ElectronMass"],
  mp -> codata["ProtonMass"],
  rp -> codata["ProtonRMSChargeRadius"],
  RH -> codata["RydbergConstant"],
  Rinf -> codata["RydbergConstant"], (* Alternative name *)
  a0 -> codata["BohrRadius"],
  \[Epsilon]0 -> codata["ElectricConstant"],
  \[Mu]0 -> codata["MagneticConstant"],
  e -> codata["ElementaryCharge"],
  G -> codata["NewtonianConstant"],
  PlanckLength -> codata["PlanckLength"],
  PlanckMass -> codata["PlanckMass"]
};

(* Add derived quantities *)
physicalConstants = Join[physicalConstants, {
  \[Mu]e -> (me mp/(me + mp)) /. physicalConstants (* reduced mass *)
}];

(* Corrected physical constant expressions *)
physicalConstantExpressions = {
  \[Alpha] -> (c e^2 \[Mu]0)/(4 \[Pi] \[HBar]),
  \[Mu]0 -> 1/(c^2 \[Epsilon]0),
  a0 -> (4 \[Pi] \[Epsilon]0 \[HBar]^2)/(me e^2),
  PlanckLength -> Sqrt[(\[HBar] G)/c^3],
  PlanckMass -> Sqrt[(\[HBar] c)/G],
  \[Mu]e -> (me mp)/(me + mp),
  RH -> (\[Alpha]^2 me c)/(2 h), (* Simplified Rydberg *)
  re -> e^2/(4 \[Pi] \[Epsilon]0 me c^2) (* classical electron radius *)
};

(* Convert to equations for use with Eliminate *)
PhysicsDefinitions = (ToEqual /@ physicalConstantExpressions);

(* Utility functions *)
RHSphysicalConstants[eq_] := First[eq] == (eq[[2]] /. physicalConstants)
RelativeError[theoretic_, measured_] := 1 - theoretic/measured

(* Geometric and physics functions *)
BlackholeRadius[mass_] := 2 G mass/c^2
BlackholeMass[radius_] := c^2 radius/(2 G)
SphereVolume[r_] := (4/3) Pi r^3
CircleArea[r_] := Pi r^2
SphereArea[r_] := 4 CircleArea[r]

(* Safe equation solving *)
SafeSolve[eq_, var_] := Module[{result},
  result = Quiet[Solve[eq, var]];
  If[result === {} || result === $Failed,
    Print["Warning: Could not solve for ", var];
    var -> Undefined,
    result[[1, 1]]
  ]
]
