-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLBUROCREDITOREPCOPIA
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLBUROCREDITOREPCOPIA`;DELIMITER $$

CREATE PROCEDURE `SOLBUROCREDITOREPCOPIA`(
	Par_FolioSol	varchar(30),
	Par_NumCon		int,

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN




declare contador 		int;
declare cantRegistros 	int;



declare nom 			varchar(50);
declare nom2 			varchar(50);
declare ap 			varchar(50);
declare am 			varchar(50);
declare nombre 		varchar(100);
declare Var_RFC 		char(13);
declare FechaNacCad 	char(10);
declare FechaNac 		date;
declare anio 			char(4);
declare mes 			char(2);
declare dia 			char(2);
declare Var_IFE 		varchar(13);
declare Var_CURP 		char(18);
declare regBCsegPN 	varchar(30);







declare	ConSegPN		int;
declare	ConSegPA		int;
declare	ConSegPE		int;
declare	ConSegIQ		int;
declare	ConSegHIHR		int;
declare	ConSegPEND1		int;
declare	ConSegPEND2		int;
declare	ConSegSC		int;

declare	Cadena_Vacia	char(1);
declare	Entero_Cero		int;
declare 	Fecha_Vacia     date;
declare	Decimal_Cero	decimal(12,4);

declare 	seg0 			char(2);
declare 	seg1 			char(2);
declare 	seg2 			char(2);
declare 	seg3 			char(2);
declare 	seg4 			char(2);
declare 	seg5 			char(2);
declare 	seg6 			char(2);
declare 	seg7 			char(2);
declare 	seg8			char(2);
declare 	seg9			char(2);
declare 	seg10			char(2);
declare 	seg11			char(2);
declare 	seg12			char(2);
declare 	seg13			char(2);
declare 	seg14			char(2);
declare 	seg15			char(2);
declare 	seg16			char(2);
declare 	segPN 			char(2);
declare 	segPA			char(2);
declare 	segPE			char(2);
declare 	segIQ			char(2);
declare 	segHI			char(2);
declare 	segHR			char(2);
declare 	segSC			char(2);





declare	Bimestral		char(1);
declare	BimeDescrip		varchar(15);

declare	Diario			char(1);
declare	DiarioDescrip	varchar(15);

declare	PorHora			char(1);
declare	PorHoDescrip	varchar(15);

declare	Catorcenal		char(1);
declare	CatorDescrip	varchar(15);

declare	Mensual			char(1);
declare	MensualDescrip	varchar(15);

declare	Quincenal		char(1);
declare	QuincDescrip	varchar(15);

declare	Semanal			char(1);
declare	SemaDescrip		varchar(15);

declare	Anual			char(1);
declare	AnualDescrip	varchar(15);



declare	UsuarioAut		char(1);
declare	Individual		char(1);
declare	Mancomunado		char(1);
declare	ObligadoSolid	char(1);
declare	RespDescUsu		varchar(30);
declare	RespDescIndiv	varchar(30);
declare	RespDescManc	varchar(30);
declare	RespDescOSol	varchar(30);

declare	MueblesCod		char(2);
declare	MuebDescrip		varchar(40);

declare	AgropecuaCod	char(2);
declare	AgropDescrip	varchar(40);

declare	ArrAutoamCod	char(2);
declare	ArrAutoDescrip	varchar(40);

declare	AviacionCod		char(2);
declare	AviacDescrip	varchar(40);

declare	ComAutoCod		char(2);
declare	ComAutoDescrip	varchar(40);

declare	FianzaCod		char(2);
declare	FianzaDescrip	varchar(40);

declare	BoteCod			char(2);
declare	BoteDescrip		varchar(40);

declare	TarjCredCod		char(2);
declare	TarjCredDescrip	varchar(40);

declare	CartasCredCod	char(2);
declare	CarCredDescrip	varchar(40);

declare	CredFiscalCod	char(2);
declare	CreFiscDescrip	varchar(40);

declare	LineaCredCod	char(2);
declare	LinCredDescrip	varchar(40);

declare	ConsolidCod		char(2);
declare	ConsolidDescrip	varchar(40);

declare	CredSimpCod		char(2);
declare	CredSimpDescrip	varchar(40);

declare	ConColaterCod	char(2);
declare	ConColaDescrip	varchar(40);

declare	DescuentCod		char(2);
declare	DescDescrip		varchar(40);

declare	EquipoCod		char(2);
declare	EquipoDescrip	varchar(40);

declare	FideicomCod		char(2);
declare	FideiDescrip	varchar(40);

declare	FactorajCod		char(2);
declare	FactoDescrip	varchar(30);

declare	HabilAvioCod	char(2);
declare	HabAvDescrip	varchar(40);

declare	HomeEquiCod		char(2);
declare	HomeEqDescrip	varchar(40);

declare	MejorCasaCod	char(2);
declare	MejCaDescrip	varchar(40);

declare	LinCreReinsCod	char(2);
declare	LCreReiDescrip	varchar(40);

declare	ArrendamienCod	char(2);
declare	ArrendaDescrip	varchar(40);

declare	OtrosCod		char(2);
declare	OtrosDescrip	varchar(40);

declare	OAdeuVencCod	char(2);
declare	OAdeVeDescrip	varchar(40);

declare	PrePFAEmpCod	char(2);
declare	PrePFAEmpDescr	varchar(70);

declare	EditorialCod	char(2);
declare	EditorDescrip	varchar(40);

declare	PreGarUnInCod	char(2);
declare	PreGarUInDescr	varchar(80);

declare	PresPersonCod	char(2);
declare	PrePerDescrip	varchar(40);

declare	PresNominaCod	char(2);
declare	PreNomiDescrip	varchar(40);

declare	QuirografCod	char(2);
declare	QuirogDescrip	varchar(40);

declare	PrendarioCod	char(2);
declare	PrendaDescrip	varchar(40);

declare	PagoServiCod	char(2);
declare	PagoSerDescrip	varchar(40);

declare	RestructCod		char(2);
declare	RestructDescrip	varchar(40);

declare	RedescuentoCod	char(2);
declare	RedescDescrip	varchar(40);

declare	BienesRaiCod	char(2);
declare	BienRaiDescrip	varchar(40);

declare	RefaccionCod	char(2);
declare	RefaccDescrip	varchar(40);

declare	RenovadoCod		char(2);
declare	RenovDescrip	varchar(40);

declare	VehicRecreCod	char(2);
declare	VehiRecDescrip	varchar(40);

declare	TarjGaranCod	char(2);
declare	TarGarDescrip	varchar(40);

declare	PresGaranCod	char(2);
declare	PreGarDescrip	varchar(40);

declare	SegurosCod		char(2);
declare	SegurosDescrip	varchar(40);

declare	SegHipotecaCod	char(2);
declare	SegHipoDescrip	varchar(40);

declare	PresEstudiaCod	char(2);
declare	PresEstDescrip	varchar(40);

declare	TarjCreEmpCod	char(2);
declare	TaCreEDescrip	varchar(40);

declare	DesconocCod		char(2);
declare	DescoDescrip	varchar(40);

declare	PresNoGarCod	char(2);
declare	PNoGarDescrip	varchar(40);


declare	Var_Otorgante	varchar(15);
declare	Var_BDDBC		varchar(15);





declare	NEndeudCod		int;
declare	NEndeudDesc		varchar(100);

declare	SaldoVenAcCod	int;
declare	SaldoVenAcDes	varchar(100);

declare	SalVAcRevCod	int;
declare	SalVAcRevDes	varchar(100);

declare	ConsRecienCod	int;
declare	ConsRecienDes	varchar(100);

declare	CtaMorHistCod	int;
declare	CtaMorHistDes	varchar(100);

declare	CtaMorCreHCod	int;
declare	CtaMorCreHDes	varchar(100);

declare	NumCtasMorCod	int;
declare	NumCtasMorDes	varchar(100);

declare	AumCtasMorCod	int;
declare	AumCtasMorDes	varchar(100);

declare	PBajAntTCreCod	int;
declare	PBajAntTCreDes	varchar(100);

declare	PBajAntTCDepCod	int;
declare	PBajAntTCDepDes	varchar(100);

declare	PBajAntTCRevCod	int;
declare	PBajAntTCRevDes	varchar(100);

declare	TCreMayRiesCod	int;
declare	TCreMayRiesDes	varchar(100);

declare	NumCtasAbieCod	int;
declare	NumCtasAbieDes	varchar(100);

declare	NumCtasRevACod	int;
declare	NumCtasRevADes	varchar(100);

declare	PropASalLimCCod	int;
declare	PropASalLimCDes	varchar(100);

declare	UltCtaApRecCod	int;
declare	UltCtaApRecDes	varchar(100);

declare	CtasMorRecCod	int;
declare	CtasMorRecDes	varchar(100);

declare	CtaMAntARecCod	int;
declare	CtaMAntARecDes	varchar(100);

declare	CtaRevMARecCod	int;
declare	CtaRevMARecDes	varchar(100);

declare	RelCtasMorYsCod	int;
declare	RelCtasMorYsDes	varchar(100);

declare	RelExpMorHCCod	int;
declare	RelExpMorHCDes	varchar(100);

declare	ConDifInstCod	int;
declare	ConDifInstDes	varchar(100);

declare	ConUlt48MCod	int;
declare	ConUlt48MDes	varchar(100);

declare	VarCtasPlazCod	int;
declare	VarCtasPlazDes	varchar(100);

declare	ConUlt6MCod		int;
declare	ConUlt6MDes		varchar(100);

declare	ConCerUl48MCod	int;
declare	ConCerUl48MDes	varchar(100);

declare	PropAlSalLCCod	int;
declare	PropAlSalLCDes	varchar(100);

declare	CtasAbUlt48Cod	int;
declare	CtasAbUlt48Des	varchar(100);




declare	SolNoAutCod	int;
declare	SolNoAutDes	varchar(45);

declare	SolSCInvalCod	int;
declare	SolSCInvalDes	varchar(45);

declare	SCNoDisponCod	int;
declare	SCNoDisponDes	varchar(45);




set	ConSegPN	:=	1;
set	ConSegPA	:=	2;
set	ConSegPE	:=	3;
set	ConSegIQ	:=	4;
set ConSegHIHR	:= 5;
set ConSegPEND1	:= 6;
set ConSegPEND2	:= 7;
set ConSegSC	:= 8;


Set	Cadena_Vacia:= '';
set	Decimal_Cero:= 0.0;
Set	Entero_Cero	:= 0;
Set	Fecha_Vacia	:= '1900-01-01';

set seg0		:= '00';
set seg1		:= '01';
set seg2		:= '02';
set seg3		:= '03';
set seg4		:= '04';
set seg5		:= '05';
set seg6		:= '06';
set seg7		:= '07';
set seg8		:= '08';
set seg9		:= '09';
set seg10		:= '10';
set seg11		:= '11';
set seg12		:= '12';
set seg13		:= '13';
set seg14		:= '14';
set seg15		:= '15';
set seg16		:= '16';
set segPN 		:= 'PN';
set segPA 		:= 'PA';
set segIQ		:= 'IQ';
set segPE		:= 'PE';
set segHI		:= 'HI';
set segHR		:= 'HR';
set segSC		:= 'SC';





set	Bimestral		:= 'B';
set	BimeDescrip		:= 'Bimestral';

set	Diario			:= 'D';
set	DiarioDescrip	:= 'Diario';

set	PorHora			:= 'H';
set	PorHoDescrip	:= 'PorHora';

set	Catorcenal		:= 'K';
set	CatorDescrip	:= 'Catorcenal';

set	Mensual			:= 'M';
set	MensualDescrip	:= 'Mensual';

set	Quincenal		:= 'S';
set	QuincDescrip	:= 'Quincenal';

set	Semanal			:= 'W';
set	SemaDescrip		:= 'Semanal';

set	Anual			:= 'Y';
set	AnualDescrip	:= 'Anual';





set	UsuarioAut		:= 'A';
set	Individual		:= 'I';
set	Mancomunado		:= 'M';
set	ObligadoSolid	:= 'C';
set	RespDescUsu		:= 'USUARIO AUTORIZADO';
set	RespDescIndiv	:= 'INDIVIDUAL';
set	RespDescManc	:= 'MANCOMUNADO';
set	RespDescOSol	:= 'OBLIGADO SOLIDARIO';

set	MueblesCod		:= 'AF';
set	MuebDescrip		:= 'APARATOS/MUEBLES';

set	AgropecuaCod	:= 'AG';
set	AgropDescrip	:= 'AGROPECUARIO(PFAE)';

set	ArrAutoamCod	:= 'AL';
set	ArrAutoDescrip	:= 'ARRENDAMIENTO AUTOMOTRIZ';

set	AviacionCod		:= 'AP';
set	AviacDescrip	:= 'AVIACION';

set	ComAutoCod		:= 'AU';
set	ComAutoDescrip	:= 'COMPRA DE AUTOMOVIL';

set	FianzaCod		:= 'BD';
set	FianzaDescrip	:= 'FIANZA';

set	BoteCod			:= 'BT';
set	BoteDescrip		:= 'BOTE / LANCHA';

set	TarjCredCod		:= 'CC';
set	TarjCredDescrip	:= 'TARJETA DE CREDITO';

set	CartasCredCod	:= 'CE';
set	CarCredDescrip	:= 'CARTAS DE CREDITO (PFAE)';

set	CredFiscalCod	:= 'CF';
set	CreFiscDescrip	:= 'CREDITO FISCAL';

set	LineaCredCod	:= 'CL';
set	LinCredDescrip	:= 'LINEA DE CREDITO';

set	ConsolidCod		:= 'CO';
set	ConsolidDescrip	:= 'CONSOLIDACION';

set	CredSimpCod		:= 'CS';
set	CredSimpDescrip	:= 'CREDITO SIMPLE (PFAE)';

set	ConColaterCod	:= 'CT';
set	ConColaDescrip	:= 'CON  COLATERAL (PFAE)';

set	DescuentCod		:= 'DE';
set	DescDescrip		:= 'DESCUENTOS (PFAE)';

set	EquipoCod		:= 'EQ';
set	EquipoDescrip	:= 'EQUIPO';

set	FideicomCod		:= 'FI';
set	FideiDescrip	:= 'FIDEICOMISO (PFAE)';

set	FactorajCod		:= 'FT';
set	FactoDescrip	:= 'FACTORAJE';

set	HabilAvioCod	:= 'HA';
set	HabAvDescrip	:= 'HABILITACION O AVIO (PFAE)';

set	HomeEquiCod		:= 'HE';
set	HomeEqDescrip	:= 'PRESTAMO TIPO HOME "EQUITY”';

set	MejorCasaCod	:= 'HI';
set	MejCaDescrip	:= 'MEJORAS A LA CASA';

set	LinCreReinsCod	:= 'LR';
set	LCreReiDescrip	:= 'LINEA DE CREDITO REINSTALABLE';

set	ArrendamienCod	:= 'LS';
set	ArrendaDescrip	:= 'ARRENDAMIENTO';

set	OtrosCod		:= 'MI';
set	OtrosDescrip	:= 'OTROS';

set	OAdeuVencCod	:= 'OA';
set	OAdeVeDescrip	:= 'OTROS ADEUDOS VENCIDOS (PFAE)';

set	PrePFAEmpCod	:= 'PA';
set	PrePFAEmpDescr	:= 'PRESTAMO PARA PERSONAS FISICAS CON ACTIVIDAD EMPRESARIAL (PFAE)';

set	EditorialCod	:= 'PB';
set	EditorDescrip	:= 'EDITORIAL';

set	PreGarUnInCod	:= 'PG';
set	PreGarUInDescr	:= 'PGUE - PRESTAMO COMO GARANTIA DE UNIDADES INDUSTRIALES PARA PFAE';

set	PresPersonCod	:= 'PL';
set	PrePerDescrip	:= 'PRESTAMO PERSONAL';

set	PresNominaCod	:= 'PN';
set	PreNomiDescrip	:= 'PRESTAMO DE NOMINA';

set	QuirografCod	:= 'PQ';
set	QuirogDescrip	:= 'QUIROGRAFARIO (PFAE)';

set	PrendarioCod	:= 'PR';
set	PrendaDescrip	:= 'Prendario (PFAE)';

set	PagoServiCod	:= 'PS';
set	PagoSerDescrip	:= 'PAGO DE SERVICIOS';

set	RestructCod		:= 'RC';
set	RestructDescrip	:= 'REESTRUCTURADO (PFAE)';

set	RedescuentoCod	:= 'RD';
set	RedescDescrip	:= 'Redescuento (PFAE)';

set	BienesRaiCod	:= 'RE';
set	BienRaiDescrip	:= 'Bienes Raíces';

set	RefaccionCod	:= 'RF';
set	RefaccDescrip	:= 'REFACCIONARIO (PFAE)';

set	RenovadoCod		:= 'RN';
set	RenovDescrip	:= 'RENOVADO (PFAE)';

set	VehicRecreCod	:= 'RV';
set	VehiRecDescrip	:= 'VEHICULO RECREATIVO';

set	TarjGaranCod	:= 'SC';
set	TarGarDescrip	:= 'TARJETA GARANTIZADA';

set	PresGaranCod	:= 'SE';
set	PreGarDescrip	:= 'PRESTAMO GARANTIZADO';

set	SegurosCod		:= 'SG';
set	SegurosDescrip	:= 'SEGUROS';

set	SegHipotecaCod	:= 'SM';
set	SegHipoDescrip	:= 'SEGUNDA HIPOTECA';

set	PresEstudiaCod	:= 'ST';
set	PresEstDescrip	:= 'PRESTAMO PARA ESTUDIANTE';

set	TarjCreEmpCod	:= 'TE';
set	TaCreEDescrip	:= 'TARJETA DE CREDITO EMPRESARIAL';

set	DesconocCod		:= 'UK';
set	DescoDescrip	:= 'DESCONOCIDO';

set	PresNoGarCod	:= 'US';
set	PNoGarDescrip	:= 'PRESTAMO NO GARANTIZADO';


set	Var_Otorgante	:= 'OTORGANTE';
set	Var_BDDBC		:= 'BDD BC';






set	NEndeudCod		:= 1;
set	NEndeudDesc		:= 'NIVEL DE ENDEUDAMIENTO';

set	SaldoVenAcCod	:= 2;
set	SaldoVenAcDes	:= 'SALDO VENCIDO ACTUAL';

set	SalVAcRevCod	:= 3;
set	SalVAcRevDes	:= 'SALDO VENCIDO ACTUAL EN CUENTAS REVOLVENTES';

set	ConsRecienCod	:= 4;
set	ConsRecienDes	:= 'CONSULTA MUY RECIENTE';

set	CtaMorHistCod	:= 5;
set	CtaMorHistDes	:= 'CUENTAS CON MOROSIDAD EN EL HISTORICO (MAXIMO 48 MESES)';

set	CtaMorCreHCod	:= 6;
set	CtaMorCreHDes	:= 'CUENTAS CON MOROSIDAD EN CREDITOS HIPOTECARIOS (MAXIMO 48 MESES)';

set	NumCtasMorCod	:= 7;
set	NumCtasMorDes	:= 'NUMERO DE CUENTAS CON MOROSIDAD';

set	AumCtasMorCod	:= 8;
set	AumCtasMorDes	:= 'AUMENTO DE CUENTAS CON MOROSIDAD';

set	PBajAntTCreCod	:= 9;
set	PBajAntTCreDes	:= 'PROMEDIO BAJO DE ANTIGÜEDAD EN EL TOTAL DE LOS CREDITOS';

set	PBajAntTCDepCod	:= 10;
set	PBajAntTCDepDes	:= 'PROMEDIO BAJO DE ANTIGÜEDAD EN EL TOTAL DE LOS CREDITOS DEPARTAMENTALES';

set	PBajAntTCRevCod	:= 11;
set	PBajAntTCRevDes	:= 'PROMEDIO BAJO DE ANTIGÜEDAD EN EL TOTAL DE LOS CREDITOS REVOLVENTES';

set	TCreMayRiesCod	:= 12;
set	TCreMayRiesDes	:= 'TIPO DE CREDITO CON MAYOR RIESGO';

set	NumCtasAbieCod	:= 13;
set	NumCtasAbieDes	:= 'NUMERO DE CUENTAS ABIERTAS';

set	NumCtasRevACod	:= 14;
set	NumCtasRevADes	:= 'NUMERO DE CUENTAS REVOLVENTES';

set	PropASalLimCCod	:= 15;
set	PropASalLimCDes	:= 'PROPORCION ALTA ENTRE SALDOS CONTRA LIMITES DE CREDITO REVOLVENTES';

set	UltCtaApRecCod	:= 16;
set	UltCtaApRecDes	:= 'ULTIMA CUENTA NUEVA APERTURADA RECIENTEMENTE';

set	CtasMorRecCod	:= 17;
set	CtasMorRecDes	:= 'CUENTAS CON MOROSIDAD RECIENTE';

set	CtaMAntARecCod	:= 18;
set	CtaMAntARecDes	:= 'CUENTA MAS ANTIGUA APERTURADA RECIENTEMENTE';

set	CtaRevMARecCod	:= 19;
set	CtaRevMARecDes	:= 'CUENTA REVOLVENTE MAS ANTIGUA APERTURADA RECIENTEMENTE';

set	RelCtasMorYsCod	:= 20;
set	RelCtasMorYsDes	:= 'RELACION ENTRE CUENTAS CON MOROSIDAD Y SIN MOROSIDAD';

set	RelExpMorHCCod	:= 21;
set	RelExpMorHCDes	:= 'RELACION ENTRE EXPERIENCIAS CON MOROSIDAD Y SIN MOROSIDAD EN EL HISTORIAL CREDITICIO';

set	ConDifInstCod	:= 22;
set	ConDifInstDes	:= 'CONSULTAS DE DIFERENTES INSTITUCIONES';

set	ConUlt48MCod	:= 23;
set	ConUlt48MDes	:= 'CONSULTAS EN LOS ULTIMOS 48 MESES';

set	VarCtasPlazCod	:= 24;
set	VarCtasPlazDes	:= 'VARIAS CUENTAS A PLAZO';

set	ConUlt6MCod		:= 26;
set	ConUlt6MDes		:= 'CONSULTAS EN LOS ULTIMOS 6 MESES';

set	ConCerUl48MCod	:= 27;
set	ConCerUl48MDes	:= 'CONSULTAS CERRADAS EN LOS ULTIMOS 48 MESES';

set	PropAlSalLCCod	:= 28;
set	PropAlSalLCDes	:= 'PROPORCION ALTA ENTRE SALDOS CONTRA LIMITES DE CREDITO';

set	CtasAbUlt48Cod	:= 29;
set	CtasAbUlt48Des	:= 'CUENTAS ABIERTAS EN LOS ULTIMOS 48 MESES';


set	SolNoAutCod		:= 1;
set	SolNoAutDes		:= 'SOLICITUD NO AUTORIZADA';

set	SolSCInvalCod	:= 2;
set	SolSCInvalDes	:= 'SOLICITUD DE SCORE INVALIDA';

set	SCNoDisponCod	:= 3;
set	SCNoDisponDes	:= 'SCORE NO DISPONIBLE';






if(Par_NumCon = ConSegPN) then

	set nom :=  (select ifnull(PN_VALOR,Cadena_Vacia)
					from 	bur_segpn
					where	BUR_SOLNUM 	= Par_FolioSol
					and 	PN_SEGMEN 	= seg2 );

	set nom2 :=  (select ifnull(PN_VALOR,Cadena_Vacia)
					from 	bur_segpn
					where	BUR_SOLNUM 	= Par_FolioSol
					and 	PN_SEGMEN 	= seg3 );


	set ap := (select  ifnull(PN_VALOR,Cadena_Vacia)
					from 	bur_segpn
					where	BUR_SOLNUM	= Par_FolioSol
					and  	PN_SEGMEN 	= segPN );



	set am :=  (select ifnull(PN_VALOR,Cadena_Vacia)
					from 	bur_segpn
					where	BUR_SOLNUM 	= Par_FolioSol
					and  	PN_SEGMEN 	= seg0 );




	set Var_RFC := (select ifnull(PN_VALOR,Cadena_Vacia)
						from 	bur_segpn
						where	BUR_SOLNUM 	= Par_FolioSol
						and  	PN_SEGMEN 	= seg5 );


	set FechaNacCad := (select 	ifnull(PN_VALOR,Cadena_Vacia)
							from 	bur_segpn
							where	BUR_SOLNUM 	= Par_FolioSol
							and  	PN_SEGMEN 	= seg4 );


	set dia := (SUBSTR(FechaNacCad,1,2) );
	set mes := (SUBSTR(FechaNacCad,3,2) );
	set anio := (SUBSTR(FechaNacCad,5,4) );


	set FechaNacCad := concat(anio,"-",mes,"-",dia);
	set FechaNac := ifnull(FechaNacCad,Fecha_Vacia);



	set Var_IFE := (select 	ifnull(PN_VALOR,Cadena_Vacia)
						from 	bur_segpn
						where	BUR_SOLNUM 	= Par_FolioSol
						and  	PN_SEGMEN 	= seg14 );

	set Var_CURP := (select 	ifnull(PN_VALOR,Cadena_Vacia)
						from 	bur_segpn
						where	BUR_SOLNUM 	= Par_FolioSol
						and  	PN_SEGMEN 	= seg15 );

	set regBCsegPN:= ifnull(regBCsegPN,Cadena_Vacia);


	set nombre:= concat(nom," ",nom2);

	select nombre, 	concat(ap," ", am)as Apellidos,	Var_RFC, 	FechaNac,	Var_IFE,
			Var_CURP,	regBCsegPN;

end if;





if(Par_NumCon = ConSegPA) then

	Create Temporary Table TMPDIRECCIONESPA
											(	Consecutivo		int,
												FolioSol 		varchar(30),
												CalleYnum 		varchar(100),
												Colonia 		varchar(50),
												DelOMunicipio 	varchar(100),
												Ciudad 			varchar(50),
												Estado			varchar(50),
												CP 				char(5),
												Telefono		varchar(20),
												RegBCsegPA		varchar(30));



	set cantRegistros := (select max(PA_CONSEC)
						from 	bur_segpa
						where 	BUR_SOLNUM = Par_FolioSol);
	set contador := 1;
	WHILE contador <= cantRegistros  DO

		insert into TMPDIRECCIONESPA (
										Consecutivo,	FolioSol,		CalleYnum,	Colonia,	DelOMunicipio,
										Ciudad,			Estado,			CP,			Telefono,	RegBCsegPA)
						values		  (	contador,		Par_FolioSol,	concat((select ifnull(PA_VALOR,Cadena_Vacia)
																		from 	bur_segpa
																		where 	BUR_SOLNUM = Par_FolioSol
																		and  	PA_SEGMEN = segPA
																		and PA_CONSEC = contador),Cadena_Vacia,
																		(select ifnull(PA_VALOR,Cadena_Vacia)
																		from 	bur_segpa
																		where 	BUR_SOLNUM = Par_FolioSol
																		and  	PA_SEGMEN = seg0
																		and PA_CONSEC = contador)),
										(select  ifnull(PA_VALOR,Cadena_Vacia)
												from 	bur_segpa
												where 	BUR_SOLNUM = Par_FolioSol
												and  	PA_SEGMEN = seg1
												and 	PA_CONSEC = contador),
										(select  ifnull(PA_VALOR,Cadena_Vacia)
												from 	bur_segpa
												where 	BUR_SOLNUM = Par_FolioSol
												and  	PA_SEGMEN = seg2
												and 	PA_CONSEC = contador),
										(select  ifnull(PA_VALOR,Cadena_Vacia)
												from 	bur_segpa
												where 	BUR_SOLNUM = Par_FolioSol
												and  	PA_SEGMEN = seg3
												and 	PA_CONSEC = contador),
										(select  ifnull(PA_VALOR,Cadena_Vacia)
												from 	bur_segpa
												where 	BUR_SOLNUM = Par_FolioSol
												and  	PA_SEGMEN = seg4
												and 	PA_CONSEC = contador),
										(select  ifnull(PA_VALOR,Cadena_Vacia)
												from 	bur_segpa
												where 	BUR_SOLNUM = Par_FolioSol
												and  	PA_SEGMEN = seg5
												and 	PA_CONSEC = contador),
										concat((select  ifnull(PA_VALOR,Cadena_Vacia)
												from 	bur_segpa
												where 	BUR_SOLNUM = Par_FolioSol
												and  	PA_SEGMEN = seg7
												and 	PA_CONSEC = contador),"  ",(select  ifnull(PA_VALOR,Cadena_Vacia)
												from 	bur_segpa
												where 	BUR_SOLNUM = Par_FolioSol
												and  	PA_SEGMEN = seg8
												and 	PA_CONSEC = contador)),
										(select  ifnull(PA_VALOR,Cadena_Vacia)
												from 	bur_segpa
												where 	BUR_SOLNUM = Par_FolioSol
												and  	PA_SEGMEN = seg6
												and 	PA_CONSEC = contador)
										);



		Set contador := contador +1;

	END WHILE;


select Consecutivo,	FolioSol,		CalleYnum,	Colonia,	DelOMunicipio,
		Ciudad,			Estado,			CP,			Telefono,	RegBCsegPA
		from TMPDIRECCIONESPA
		where FolioSol = Par_FolioSol;


drop table TMPDIRECCIONESPA;
end if;




if(Par_NumCon = ConSegPE) then

	Create Temporary Table TMPDIRECCIONESPE
											(	Consecutivo		int,
												FolioSol 		varchar(30),
												Compañia		varchar(40),
												Puesto			varchar(30),
												Salario			decimal(12,4),
												Base			char(1),
												CalleYnum 		varchar(100),
												Colonia 		varchar(50),
												DelOMunicipio 	varchar(100),
												Ciudad 			varchar(50),
												Estado			varchar(50),
												CP 				char(5),
												Telefono		varchar(20),
												RegBCsegPE		varchar(30),
												FechContrata	varchar(15),
												UltDiaEmpleo	varchar(12));



	set cantRegistros := (select max(PE_CONSEC)
						from 	bur_segpe
						where 	BUR_SOLNUM = '0000000020');
	set contador := 1;
	WHILE contador <= cantRegistros  DO

		set FechaNacCad :="";
		set FechaNacCad := (select ifnull(PE_VALOR,Fecha_Vacia)
										from 	bur_segpe
										where 	BUR_SOLNUM = '0000000020'
										and  	PE_SEGMEN = seg11
										and 	PE_CONSEC = contador);

set FechaNacCad :=  (SELECT LTRIM(FechaNacCad));
		set dia := (SUBSTR(FechaNacCad,1,2) );
		set mes := (SUBSTR(FechaNacCad,3,2) );
		set anio := (SUBSTR(FechaNacCad,5,4) );
		set FechaNacCad := concat(anio,"-",mes,"-",dia);









		insert into TMPDIRECCIONESPE (
										Consecutivo,	FolioSol,		Compañia,		Puesto,			Salario,
										Base,			CalleYnum,		Colonia,		DelOMunicipio,	Ciudad,
										Estado,			CP,				Telefono,		RegBCsegPE,		FechContrata,
										UltDiaEmpleo)
						values		  (	contador,		'0000000020',	(select ifnull(PE_VALOR,Cadena_Vacia)
																		from 	bur_segpe
																		where 	BUR_SOLNUM = '0000000020'
																		and  	PE_SEGMEN = segPE
																		and PE_CONSEC = contador),

										(select ifnull(PE_VALOR,Cadena_Vacia)
												from 	bur_segpe
												where 	BUR_SOLNUM = '0000000020'
												and  	PE_SEGMEN = seg10
												and PE_CONSEC = contador),
										(select  ifnull(PE_VALOR,Cadena_Vacia)
												from 	bur_segpe
												where 	BUR_SOLNUM = '0000000020'
												and  	PE_SEGMEN = seg13
												and 	PE_CONSEC = contador),
										(select  ifnull(PE_VALOR,Cadena_Vacia)
												from 	bur_segpe
												where 	BUR_SOLNUM = '0000000020'
												and  	PE_SEGMEN = seg14
												and 	PE_CONSEC = contador),

										concat((select ifnull(PE_VALOR,Cadena_Vacia)
												from 	bur_segpe
												where 	BUR_SOLNUM = '0000000020'
												and  	PE_SEGMEN = seg0
												and PE_CONSEC = contador),Cadena_Vacia,
												(select ifnull(PE_VALOR,Cadena_Vacia)
												from 	bur_segpe
												where 	BUR_SOLNUM = '0000000020'
												and  	PE_SEGMEN = seg1
												and PE_CONSEC = contador)),

										(select  ifnull(PE_VALOR,Cadena_Vacia)
												from 	bur_segpe
												where 	BUR_SOLNUM = '0000000020'
												and  	PE_SEGMEN = seg2
												and 	PE_CONSEC = contador),
										(select  ifnull(PE_VALOR,Cadena_Vacia)
												from 	bur_segpe
												where 	BUR_SOLNUM = '0000000020'
												and  	PE_SEGMEN = seg3
												and 	PE_CONSEC = contador),
										(select  ifnull(PE_VALOR,Cadena_Vacia)
												from 	bur_segpe
												where 	BUR_SOLNUM = '0000000020'
												and  	PE_SEGMEN = seg4
												and 	PE_CONSEC = contador),
										(select  ifnull(PE_VALOR,Cadena_Vacia)
												from 	bur_segpe
												where 	BUR_SOLNUM = '0000000020'
												and  	PE_SEGMEN = seg5
												and 	PE_CONSEC = contador),
										(select  ifnull(PE_VALOR,Cadena_Vacia)
												from 	bur_segpe
												where 	BUR_SOLNUM = '0000000020'
												and  	PE_SEGMEN = seg6
												and 	PE_CONSEC = contador),
										(select  ifnull(PE_VALOR,Cadena_Vacia)
												from 	bur_segpe
												where 	BUR_SOLNUM = '0000000020'
												and  	PE_SEGMEN = seg7
												and 	PE_CONSEC = contador),
										Cadena_Vacia,
										FechaNacCad,
										(select  ifnull(PE_VALOR,Cadena_Vacia)
												from 	bur_segpe
												where 	BUR_SOLNUM = '0000000020'
												and  	PE_SEGMEN = seg16
												and 	PE_CONSEC = contador)
										);



		Set contador := contador +1;

	END WHILE;


select Consecutivo,	FolioSol,		Compañia,		Puesto,			Salario,
		 (CASE Base
		WHEN  Bimestral  		THEN BimeDescrip
		WHEN  Diario  			THEN DiarioDescrip
		WHEN  PorHora  			THEN PorHoDescrip
		WHEN  Catorcenal  		THEN CatorDescrip
		WHEN  Mensual  			THEN MensualDescrip
		WHEN  Quincenal  		THEN QuincDescrip
		WHEN  Semanal  			THEN SemaDescrip
		WHEN  Anual  			THEN AnualDescrip
		END) as DescripBase,
		CalleYnum,		Colonia,		DelOMunicipio,	Ciudad,			Estado,
		CP,				Telefono,		RegBCsegPE,		FechContrata,	UltDiaEmpleo
		from TMPDIRECCIONESPE
		where FolioSol = '0000000020';


   drop table TMPDIRECCIONESPE;
end if;




if(Par_NumCon = ConSegIQ) then

set cantRegistros := (select max(IQ_CONSEC)
						from 	bur_segiq
						where 	BUR_SOLNUM = Par_FolioSol);


	Create Temporary Table TMPCONSULTASIQ
											(	Consecutivo		int,
												FolioSol 		varchar(30),
												Otorgante 		varchar(16),
												FechConsulta 	date,
												Responsabilidad	char(1),
												TipoContrato	char(2),
												Importe			decimal(12,4),
												TipoMoneda		char(2));

	set contador := 1;
	WHILE contador <= cantRegistros  DO

		set FechaNacCad :="";
		set FechaNacCad := (select ifnull(IQ_VALOR,Fecha_Vacia)
										from 	bur_segiq
										where 	BUR_SOLNUM = Par_FolioSol
										and  	IQ_SEGMEN = segIQ
										and 	IQ_CONSEC = contador);

		set dia := (SUBSTR(FechaNacCad,1,2) );
		set mes := (SUBSTR(FechaNacCad,3,2) );
		set anio := (SUBSTR(FechaNacCad,5,4) );


		set FechaNacCad := concat(anio,"-",mes,"-",dia);

		insert into TMPCONSULTASIQ (
										Consecutivo,	FolioSol,		Otorgante,	FechConsulta,	Responsabilidad,
										TipoContrato,	Importe,		TipoMoneda)
						values		  (	contador,		Par_FolioSol,	(select ifnull(IQ_VALOR,Cadena_Vacia)
																		from 	bur_segiq
																		where 	BUR_SOLNUM = Par_FolioSol
																		and  	IQ_SEGMEN = seg2
																		and 	IQ_CONSEC = contador),
										FechaNacCad,
										(select ifnull(IQ_VALOR,Cadena_Vacia)
										from 	bur_segiq
										where 	BUR_SOLNUM = Par_FolioSol
										and  	IQ_SEGMEN = seg7
										and 	IQ_CONSEC = contador),
										(select ifnull(IQ_VALOR,Cadena_Vacia)
										from 	bur_segiq
										where 	BUR_SOLNUM = Par_FolioSol
										and  	IQ_SEGMEN = seg4
										and 	IQ_CONSEC = contador),
										(select ifnull(IQ_VALOR,Decimal_Cero)
										from 	bur_segiq
										where 	BUR_SOLNUM = Par_FolioSol
										and  	IQ_SEGMEN = seg6
										and 	IQ_CONSEC = contador),
										(select ifnull(IQ_VALOR,Cadena_Vacia)
										from 	bur_segiq
										where 	BUR_SOLNUM = Par_FolioSol
										and  	IQ_SEGMEN = seg5
										and 	IQ_CONSEC = contador)
										);



		Set contador := contador +1;

	END WHILE;



select Consecutivo,	FolioSol,	Otorgante,	FechConsulta,
	   (CASE Responsabilidad
		WHEN  UsuarioAut  		THEN RespDescUsu
		WHEN  Individual  		THEN RespDescIndiv
		WHEN  Mancomunado  		THEN RespDescManc
		WHEN  ObligadoSolid  	THEN RespDescOSol
		END) as DescripRespons,
		(CASE TipoContrato
		WHEN  MueblesCod 		THEN MuebDescrip
		WHEN  AgropecuaCod  	THEN AgropDescrip
		WHEN  ArrAutoamCod  	THEN ArrAutoDescrip
		WHEN  AviacionCod  		THEN AviacDescrip
		WHEN  ComAutoCod  		THEN ComAutoDescrip
		WHEN  FianzaCod  		THEN FianzaDescrip
		WHEN  BoteCod  			THEN BoteDescrip
		WHEN  TarjCredCod  		THEN TarjCredDescrip
		WHEN  CartasCredCod  	THEN CarCredDescrip
		WHEN  CredFiscalCod  	THEN CreFiscDescrip
		WHEN  LineaCredCod  	THEN LinCredDescrip
		WHEN  ConsolidCod  		THEN ConsolidDescrip
		WHEN  CredSimpCod  		THEN CredSimpDescrip
		WHEN  ConColaterCod  	THEN ConColaDescrip
		WHEN  DescuentCod  		THEN DescDescrip
		WHEN  EquipoCod  		THEN EquipoDescrip
		WHEN  FideicomCod  		THEN FideiDescrip
		WHEN  FactorajCod  		THEN FactoDescrip
		WHEN  HabilAvioCod 		THEN HabAvDescrip
		WHEN  HomeEquiCod  		THEN HomeEqDescrip
		WHEN  MejorCasaCod  	THEN MejCaDescrip
		WHEN  LinCreReinsCod  	THEN LCreReiDescrip
		WHEN  ArrendamienCod  	THEN ArrendaDescrip
		WHEN  OtrosCod  		THEN OtrosDescrip
		WHEN  OAdeuVencCod  	THEN OAdeVeDescrip
		WHEN  PrePFAEmpCod  	THEN PrePFAEmpDescr
		WHEN  EditorialCod  	THEN EditorDescrip
		WHEN  PreGarUnInCod  	THEN PreGarUInDescr
		WHEN  PresPersonCod  	THEN PrePerDescrip
		WHEN  PresNominaCod  	THEN PreNomiDescrip
		WHEN  QuirografCod  	THEN QuirogDescrip
		WHEN  PrendarioCod  	THEN PrendaDescrip
		WHEN  PagoServiCod  	THEN PagoSerDescrip
		WHEN  RestructCod  		THEN RestructDescrip
		WHEN  RedescuentoCod  	THEN RedescDescrip
		WHEN  BienesRaiCod  	THEN BienRaiDescrip
		WHEN  RefaccionCod  	THEN RefaccDescrip
		WHEN  RenovadoCod  		THEN RenovDescrip
		WHEN  VehicRecreCod  	THEN VehiRecDescrip
		WHEN  TarjGaranCod  	THEN TarGarDescrip
		WHEN  PresGaranCod  	THEN PreGarDescrip
		WHEN  SegurosCod  		THEN SegurosDescrip
		WHEN  SegHipotecaCod  	THEN SegHipoDescrip
		WHEN  PresEstudiaCod  	THEN PresEstDescrip
		WHEN  TarjCreEmpCod 	THEN TaCreEDescrip
		WHEN  DesconocCod  		THEN DescoDescrip
		WHEN  PresNoGarCod  	THEN PNoGarDescrip

		END) as DescTipoContrato,

	Importe,	TipoMoneda
		from TMPCONSULTASIQ
		where FolioSol = Par_FolioSol;


 drop table TMPCONSULTASIQ;



end if;



if(Par_NumCon = ConSegHIHR) then

	Create Temporary Table TMPMENSALERTAHIHR
											(	Consecutivo		int,
												FolioSol 		varchar(30),
												FechaRep		varchar(15),
												Clave			char(3),
												Otorgante		varchar(16),
												Mensaje			varchar(150),
												Origen			char(2));

set cantRegistros := (select max(HI_CONSEC)
						from 	bur_seghi
						where 	BUR_SOLNUM = Par_FolioSol);
	set contador := 1;
	WHILE contador <= cantRegistros  DO

		set FechaNacCad :="";
		set FechaNacCad := (select ifnull(HI_VALOR,Fecha_Vacia)
										from 	bur_seghi
										where 	BUR_SOLNUM = Par_FolioSol
										and  	HI_SEGMEN = segHI
										and 	HI_CONSEC = contador);
		set dia := (SUBSTR(FechaNacCad,1,2) );
		set mes := (SUBSTR(FechaNacCad,3,2) );
		set anio := (SUBSTR(FechaNacCad,5,4) );
		set FechaNacCad := concat(anio,"-",mes,"-",dia);


		insert into TMPMENSALERTAHIHR (
										Consecutivo,	FolioSol,		FechaRep,		Clave,		Otorgante,
										Mensaje,		Origen)
						values		  (	contador,		Par_FolioSol,	FechaNacCad,	(select ifnull(HI_VALOR,Cadena_Vacia)
																							from 	bur_seghi
																							where 	BUR_SOLNUM = Par_FolioSol
																							and  	HI_SEGMEN = seg0
																							and HI_CONSEC = contador),

										(select ifnull(HI_VALOR,Cadena_Vacia)
												from 	bur_seghi
												where 	BUR_SOLNUM = Par_FolioSol
												and  	HI_SEGMEN = seg1
												and 	HI_CONSEC = contador),
										(select  ifnull(HI_VALOR,Cadena_Vacia)
												from 	bur_seghi
												where 	BUR_SOLNUM = Par_FolioSol
												and  	HI_SEGMEN = seg2
												and 	HI_CONSEC = contador),
										segHI);

	Set contador := contador +1;

	END WHILE;


set cantRegistros := (select max(HR_CONSEC)
						from 	bur_seghr
						where 	BUR_SOLNUM = Par_FolioSol);
	set contador := 1;
	WHILE contador <= cantRegistros  DO
		set FechaNacCad :="";
		set FechaNacCad := (select ifnull(HR_VALOR,Fecha_Vacia)
										from 	bur_seghr
										where 	BUR_SOLNUM = Par_FolioSol
										and  	HR_SEGMEN = segHR
										and 	HR_CONSEC = contador);
		set dia := (SUBSTR(FechaNacCad,1,2) );
		set mes := (SUBSTR(FechaNacCad,3,2) );
		set anio := (SUBSTR(FechaNacCad,5,4) );
		set FechaNacCad := concat(anio,"-",mes,"-",dia);

		insert into TMPMENSALERTAHIHR (
										Consecutivo,	FolioSol,		FechaRep,		Clave,		Otorgante,
										Mensaje,		Origen)
						values		  (	contador,		Par_FolioSol,	FechaNacCad,	(select ifnull(HR_VALOR,Cadena_Vacia)
																							from 	bur_seghr
																							where 	BUR_SOLNUM = Par_FolioSol
																							and  	HR_SEGMEN = seg0
																							and 	HR_CONSEC = contador),

										(select ifnull(HR_VALOR,Cadena_Vacia)
												from 	bur_seghr
												where 	BUR_SOLNUM = Par_FolioSol
												and  	HR_SEGMEN = seg1
												and 	HR_CONSEC = contador),
										(select  ifnull(HR_VALOR,Cadena_Vacia)
												from 	bur_seghr
												where 	BUR_SOLNUM = Par_FolioSol
												and  	HR_SEGMEN = seg2
												and 	HR_CONSEC = contador),
										segHR);

	Set contador := contador +1;

	END WHILE;
set	Var_Otorgante	:= 'OTORGANTE';
set	Var_BDDBC		:= 'BDD BC';

	select Consecutivo,	FolioSol,		FechaRep,		Clave,		Otorgante,
			Mensaje,		(CASE Origen
							WHEN  segHI  		THEN   Var_Otorgante
							WHEN  segHR  		THEN 	Var_BDDBC
							END) as Origen
			from TMPMENSALERTAHIHR
			where FolioSol = Par_FolioSol;


	   drop table TMPMENSALERTAHIHR;



end if;



if(Par_NumCon = ConSegPEND1) then
    select  'TOT:' as MOP,
            5 as CueAbiertas,
            41000.00 as LimAbiertas,
            39000.00 as MaxAbiertas,
            6708.00 as SalActAbiertas,
            0.00 as SalVenAbiertas,
            1876.00 as PagoRealizar,
            0 as CueCerradas,
            0.00 as LimCerradas,
            0.00 as MaxCerradas,
            0.00 as SalActCerradas,
            0.00 as MontoCerradas;

end if;

if(Par_NumCon = ConSegPEND2) then
    select  'AMEXCO' as Otorgante,
            '376671687394001' as NumCuenta,
            'TARJETA DE CREDITO' as TipoCredito,
            'REVOLVENTE' as TipCuenta,
            'INDIVIDUAL' as Respons,
            'MN' as Moneda,
            '14-sep-2009' as FecApertura,
            '13-ago-2012' as FecActualiza,
            '17-jul-2012' as FecUltPago,
            '5-jul-2012' as FecUltCompra,
            '-' as FecCierre,
            '12-mar-2012' as FecSaldoCero,
            41000 as LimiteCredito,
            39000 as CreditoMaximo,
            6708.00 as SalActual,
            0 as SalVencido,
            1876.00 as MontoAPagar,
            '01=CUENTA CON PAGO PUNTUAL Y ADECUADO' as FormaPago,
            '' as MOP,
            '-' as FecMaxMora,
            0 as MontoMaxMora,
            '2012' as MesHisPago1,
            '2011' as MesHisPago2,
            '2010' as MesHisPago3,
            '1  1  1  1  1  1  1  1  1  1  -  -' as ClaHisPago1,
            '1  1  1  1  1  1  1  1  1  1  1 1' as ClaHisPago2,
            '1  1  1  1  1  1  1  1  1  1  1 1' as ClaHisPago3;

end if;

if(Par_NumCon = ConSegSC) then

	set cantRegistros := (select max(SC_CONSEC)
						from 	bur_segsc
						where 	BUR_SOLNUM = Par_FolioSol);


	Create Temporary Table TMPCONSULTASSC
											(	Consecutivo		int,
												FolioSol 		varchar(30),
												NombreSC 		varchar(30),
												ValorSC 		char(4),
												Causa1			char(3),
												Causa2			char(3),
												Causa3			char(3),
												CausaNoSC		char(2));

	set contador := 1;
	WHILE contador <= cantRegistros  DO


		insert into TMPCONSULTASSC (
										Consecutivo,	FolioSol,		NombreSC,	ValorSC,	Causa1,
										Causa2,			Causa3,			CausaNoSC)
						values		  (	contador,		Par_FolioSol,	(select ifnull(SC_VALOR,Cadena_Vacia)
																		from 	bur_segsc
																		where 	BUR_SOLNUM = Par_FolioSol
																		and  	SC_SEGMEN = segSC
																		and 	SC_CONSEC = contador),

										(select ifnull(SC_VALOR,Cadena_Vacia)
										from 	bur_segsc
										where 	BUR_SOLNUM = Par_FolioSol
										and  	SC_SEGMEN = seg1
										and 	SC_CONSEC = contador),
										(select ifnull(SC_VALOR,Cadena_Vacia)
										from 	bur_segsc
										where 	BUR_SOLNUM = Par_FolioSol
										and  	SC_SEGMEN = seg2
										and 	SC_CONSEC = contador),
										(select ifnull(SC_VALOR,Decimal_Cero)
										from 	bur_segsc
										where 	BUR_SOLNUM = Par_FolioSol
										and  	SC_SEGMEN = seg3
										and 	SC_CONSEC = contador),
										(select ifnull(SC_VALOR,Cadena_Vacia)
										from 	bur_segsc
										where 	BUR_SOLNUM = Par_FolioSol
										and  	SC_SEGMEN = seg4
										and 	SC_CONSEC = contador),
										(select ifnull(SC_VALOR,Cadena_Vacia)
										from 	bur_segsc
										where 	BUR_SOLNUM = Par_FolioSol
										and  	SC_SEGMEN = seg6
										and 	SC_CONSEC = contador)
										);



		Set contador := contador +1;

	END WHILE;


select Consecutivo,	FolioSol,	NombreSC,	ValorSC,
	   (CASE Causa1
		WHEN  NEndeudCod  		THEN NEndeudDesc
		WHEN  SaldoVenAcCod  	THEN SaldoVenAcDes
		WHEN  SalVAcRevCod  	THEN SalVAcRevDes
		WHEN  ConsRecienCod  	THEN ConsRecienDes
		WHEN  CtaMorHistCod  	THEN CtaMorHistDes
		WHEN  CtaMorCreHCod  	THEN CtaMorCreHDes
		WHEN  NumCtasMorCod  	THEN NumCtasMorDes
		WHEN  AumCtasMorCod  	THEN AumCtasMorDes
		WHEN  PBajAntTCreCod  	THEN PBajAntTCreDes
		WHEN  PBajAntTCDepCod  	THEN PBajAntTCDepDes
		WHEN  PBajAntTCRevCod  	THEN PBajAntTCRevDes
		WHEN  TCreMayRiesCod  	THEN TCreMayRiesDes
		WHEN  NumCtasAbieCod  	THEN NumCtasAbieDes
		WHEN  NumCtasRevACod  	THEN NumCtasRevADes
		WHEN  PropASalLimCCod  	THEN PropASalLimCDes
		WHEN  UltCtaApRecCod  	THEN UltCtaApRecDes
		WHEN  CtasMorRecCod  	THEN CtasMorRecDes
		WHEN  CtaMAntARecCod  	THEN CtaMAntARecDes
		WHEN  CtaRevMARecCod  	THEN CtaRevMARecDes
		WHEN  RelCtasMorYsCod  	THEN RelCtasMorYsDes
		WHEN  RelExpMorHCCod  	THEN RelExpMorHCDes
		WHEN  ConDifInstCod  	THEN ConDifInstDes
		WHEN  ConUlt48MCod  	THEN ConUlt48MDes
		WHEN  VarCtasPlazCod  	THEN VarCtasPlazDes
		WHEN  ConUlt6MCod  	THEN ConUlt6MDes
		WHEN  ConCerUl48MCod  	THEN ConCerUl48MDes
		WHEN  PropAlSalLCCod  	THEN PropAlSalLCDes
		WHEN  CtasAbUlt48Cod  	THEN CtasAbUlt48Des
		END) as DescripCausa1,
		 (CASE Causa2
		WHEN  NEndeudCod  		THEN NEndeudDesc
		WHEN  SaldoVenAcCod  	THEN SaldoVenAcDes
		WHEN  SalVAcRevCod  	THEN SalVAcRevDes
		WHEN  ConsRecienCod  	THEN ConsRecienDes
		WHEN  CtaMorHistCod  	THEN CtaMorHistDes
		WHEN  CtaMorCreHCod  	THEN CtaMorCreHDes
		WHEN  NumCtasMorCod  	THEN NumCtasMorDes
		WHEN  AumCtasMorCod  	THEN AumCtasMorDes
		WHEN  PBajAntTCreCod  	THEN PBajAntTCreDes
		WHEN  PBajAntTCDepCod  	THEN PBajAntTCDepDes
		WHEN  PBajAntTCRevCod  	THEN PBajAntTCRevDes
		WHEN  TCreMayRiesCod  	THEN TCreMayRiesDes
		WHEN  NumCtasAbieCod  	THEN NumCtasAbieDes
		WHEN  NumCtasRevACod  	THEN NumCtasRevADes
		WHEN  PropASalLimCCod  	THEN PropASalLimCDes
		WHEN  UltCtaApRecCod  	THEN UltCtaApRecDes
		WHEN  CtasMorRecCod  	THEN CtasMorRecDes
		WHEN  CtaMAntARecCod  	THEN CtaMAntARecDes
		WHEN  CtaRevMARecCod  	THEN CtaRevMARecDes
		WHEN  RelCtasMorYsCod  	THEN RelCtasMorYsDes
		WHEN  RelExpMorHCCod  	THEN RelExpMorHCDes
		WHEN  ConDifInstCod  	THEN ConDifInstDes
		WHEN  ConUlt48MCod  	THEN ConUlt48MDes
		WHEN  VarCtasPlazCod  	THEN VarCtasPlazDes
		WHEN  ConUlt6MCod  	THEN ConUlt6MDes
		WHEN  ConCerUl48MCod  	THEN ConCerUl48MDes
		WHEN  PropAlSalLCCod  	THEN PropAlSalLCDes
		WHEN  CtasAbUlt48Cod  	THEN CtasAbUlt48Des
		END) as DescripCausa2,
		(CASE Causa3
		WHEN  NEndeudCod  		THEN NEndeudDesc
		WHEN  SaldoVenAcCod  	THEN SaldoVenAcDes
		WHEN  SalVAcRevCod  	THEN SalVAcRevDes
		WHEN  ConsRecienCod  	THEN ConsRecienDes
		WHEN  CtaMorHistCod  	THEN CtaMorHistDes
		WHEN  CtaMorCreHCod  	THEN CtaMorCreHDes
		WHEN  NumCtasMorCod  	THEN NumCtasMorDes
		WHEN  AumCtasMorCod  	THEN AumCtasMorDes
		WHEN  PBajAntTCreCod  	THEN PBajAntTCreDes
		WHEN  PBajAntTCDepCod  	THEN PBajAntTCDepDes
		WHEN  PBajAntTCRevCod  	THEN PBajAntTCRevDes
		WHEN  TCreMayRiesCod  	THEN TCreMayRiesDes
		WHEN  NumCtasAbieCod  	THEN NumCtasAbieDes
		WHEN  NumCtasRevACod  	THEN NumCtasRevADes
		WHEN  PropASalLimCCod  	THEN PropASalLimCDes
		WHEN  UltCtaApRecCod  	THEN UltCtaApRecDes
		WHEN  CtasMorRecCod  	THEN CtasMorRecDes
		WHEN  CtaMAntARecCod  	THEN CtaMAntARecDes
		WHEN  CtaRevMARecCod  	THEN CtaRevMARecDes
		WHEN  RelCtasMorYsCod  	THEN RelCtasMorYsDes
		WHEN  RelExpMorHCCod  	THEN RelExpMorHCDes
		WHEN  ConDifInstCod  	THEN ConDifInstDes
		WHEN  ConUlt48MCod  	THEN ConUlt48MDes
		WHEN  VarCtasPlazCod  	THEN VarCtasPlazDes
		WHEN  ConUlt6MCod  	THEN ConUlt6MDes
		WHEN  ConCerUl48MCod  	THEN ConCerUl48MDes
		WHEN  PropAlSalLCCod  	THEN PropAlSalLCDes
		WHEN  CtasAbUlt48Cod  	THEN CtasAbUlt48Des
		END) as DescripCausa3,
		(CASE CausaNoSC
		WHEN  SolNoAutCod  		THEN SolNoAutDes
		WHEN  SolSCInvalCod  	THEN SolSCInvalDes
		WHEN  SCNoDisponCod  	THEN SCNoDisponDes
		END) as DescripNoCausa
		from TMPCONSULTASSC
		where FolioSol = Par_FolioSol;

 drop table TMPCONSULTASSC;

end if;



END TerminaStore$$