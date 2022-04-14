-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RECAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `RECAREP`;DELIMITER $$

CREATE PROCEDURE `RECAREP`(
		Par_SolicicitudID	int(11),

		Par_EmpresaID		int,
		Aud_Usuario			int,
		Aud_FechaActual		datetime,
		Aud_DireccionIP		varchar(15),
		Aud_ProgramaID		varchar(50),
		Aud_Sucursal		int,
		Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

declare S char(1);
declare C char(1);
declare Q char(1);
declare M char(1);
declare P char(1);
declare R char(1);
declare E char(1);
declare A char(1);
declare L char(1);
declare B char(1);
declare T char(1);
declare Semanas varchar(10);
declare Catorcenas varchar(10);
declare Quincenas varchar(10);
declare Meses		varchar(10);
declare Periodos 	varchar(10);
declare Bimestres	varchar(10);
declare Trimestres varchar(10);
declare TetraMestres varchar(11);
declare Semestres		varchar(10);
declare Anios			varchar(10);
declare Libres			varchar(10);
declare Semana varchar(10);
declare Catorcena varchar(10);
declare Quincena varchar(10);
declare Mes		varchar(10);
declare Periodo 	varchar(10);
declare Bimestre	varchar(10);
declare Trimestre varchar(10);
declare TetraMestre varchar(11);
declare Semestre		varchar(10);
declare Anio			varchar(10);
declare Libre			varchar(10);
declare Sin_Espacio		varchar(1);
declare  Cadena_Vacia	varchar(2);
declare Var_NumAmo		int(11);
declare Entero_Uno		int(11);

set S 	:='S';
set C 	:='C';
set Q	:='Q';
set M	:='M';
set P	:='P';
set R	:='R';
set E	:='E';
set A 	:='A';
set L 	:='L';
set B	:='B';
set T	:='T';
set Semanas			:='Semanas';
set Catorcenas 		:='Catorcenas';
set Quincenas		:='Quincenas';
set Meses			:='Meses';
set Periodos 		:='Periodos';
set Bimestres		:='Bimestres';
set Trimestres 		:='Trimestres';
set TetraMestres 	:='TetraMestres';
set Semestres		:='Semestres';
set Anios			:='Años';
set Libres			:='Libres';
set Sin_Espacio		:='';
set Cadena_Vacia	:=' ';
set Semana			:='Semana';
set Catorcena 		:='Catorcena';
set Quincena		:='Quincena';
set Mes				:='Mes';
set Periodo 		:='Periodo';
set Bimestre		:='Bimestre';
set Trimestre 		:='Trimestre';
set TetraMestre 	:='TetraMestre';
set Semestre		:='Semestre';
set Anio			:='Año';
set Libre			:='Libre';
set Anio			:='Año';
set Entero_Uno		:=1;
Select NumAmortizacion
	into Var_NumAmo
	from SOLICITUDCREDITO
	WHERE SolicitudCreditoID = Par_SolicicitudID
	limit 1;

if(Var_NumAmo > Entero_Uno)then
Select sol.SolicitudCreditoID, sol.MontoSolici,		sol.ClienteID, sol.FrecuenciaInt, sol.NumAmortizacion,
		sol.MontoCuota,			FUNCIONLETRASFECHA(sol.FechaRegistro) AS FechaR,	ifnull(cli.NoEmpleado,0) as NoEmpleado,
	case  sol.FrecuenciaInt
		when S then Semanas
		when C then Catorcenas
		when Q then Quincenas
		when M then Meses
		when P then Periodos
		when B then Bimestres
		when T then Trimestres
		when R then TetraMestres
		when E then Semestres
		when A then Anios
		when L then Libres
		else Sin_Espacio	end as Frecuencia,concat(cli.PrimerNombre,
            (case
                when ifnull(cli.SegundoNombre, Sin_Espacio) != Sin_Espacio then concat(Cadena_Vacia, cli.SegundoNombre)
                else Sin_Espacio
            end),
            (case
                when ifnull(cli.TercerNombre, Sin_Espacio) != Sin_Espacio then concat(Cadena_Vacia, cli.TercerNombre)
                else Sin_Espacio
            end),Cadena_Vacia,cli.ApellidoPaterno,Cadena_Vacia,cli.ApellidoMaterno) AS NombreCompleto, pro.RegistroRECA
	from SOLICITUDCREDITO	sol,
			CLIENTES cli,
			PRODUCTOSCREDITO pro
	where sol.SolicitudCreditoID = Par_SolicicitudID
	and cli.ClienteID = sol.ClienteID
	and sol.ProductoCreditoID = pro.ProducCreditoID;
else
Select sol.SolicitudCreditoID, sol.MontoSolici,		sol.ClienteID, sol.FrecuenciaInt, sol.NumAmortizacion,
		sol.MontoCuota,		FUNCIONLETRASFECHA(sol.FechaRegistro) as FechaR,	ifnull(cli.NoEmpleado,0) as NoEmpleado,
	case  sol.FrecuenciaInt
		when S then Semana
		when C then Catorcena
		when Q then Quincena
		when M then Mes
		when P then Periodo
		when B then Bimestre
		when T then Trimestre
		when R then TetraMestre
		when E then Semestre
		when A then Anio
		when L then Libre
		else Sin_Espacio	end as Frecuencia,concat(cli.PrimerNombre,
            (case
                when ifnull(cli.SegundoNombre, Sin_Espacio) != Sin_Espacio then concat(Cadena_Vacia, cli.SegundoNombre)
                else Sin_Espacio
            end),
            (case
                when ifnull(cli.TercerNombre, Sin_Espacio) != Sin_Espacio then concat(Cadena_Vacia, cli.TercerNombre)
                else Sin_Espacio
            end),Cadena_Vacia,cli.ApellidoPaterno,Cadena_Vacia,cli.ApellidoMaterno) AS NombreCompleto, pro.RegistroRECA
	from SOLICITUDCREDITO	sol,
			CLIENTES cli,
			PRODUCTOSCREDITO pro
	where sol.SolicitudCreditoID = Par_SolicicitudID
	and cli.ClienteID = sol.ClienteID
	and sol.ProductoCreditoID = pro.ProducCreditoID;
end if;

END TerminaStore$$