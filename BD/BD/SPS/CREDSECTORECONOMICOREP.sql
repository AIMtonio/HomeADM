-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDSECTORECONOMICOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDSECTORECONOMICOREP`;DELIMITER $$

CREATE PROCEDURE `CREDSECTORECONOMICOREP`(
	# SP para generar el reporte de Creditos por Sector Economico
	Par_FechaOperacion	DATE,				# Fecha para generar el Reporte
	Par_NumRep			TINYINT UNSIGNED,	# Numero de Reporte

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT
		)
TerminaStore: BEGIN

# Declaracion de Variables
DECLARE Var_PorcentajeAgri		DECIMAL(10,2);	 # Porcentaje Parametrizado Agricultura Ganaderia Pesca
DECLARE Var_PorcentajeAma		DECIMAL(10,2);	 # Porcentaje Parametrizado Amas de Casa
DECLARE Var_PorcentajeArre		DECIMAL(10,2);	 # Porcentaje Parametrizado Arrendadores
DECLARE Var_PorcentajeComEst	DECIMAL(10,2);	 # Porcentaje Parametrizado Comercial Establecido
DECLARE Var_PorcentajeDoc		DECIMAL(10,2);	 # Porcentaje Parametrizado Docentes

DECLARE Var_PorcentajeEmple		DECIMAL(10,2);	 # Porcentaje Parametrizado Empleados
DECLARE Var_PorcentajeEmpre		DECIMAL(10,2);	 # Porcentaje Parametrizado Empresarios
DECLARE Var_PorcentajeEst		DECIMAL(10,2);	 # Porcentaje Parametrizado Estudiantes
DECLARE Var_PorcentajeOfi		DECIMAL(10,2);	 # Porcentaje Parametrizado Oficios
DECLARE Var_PorcentajePen		DECIMAL(10,2);	 # Porcentaje Parametrizado Pensionados

DECLARE Var_PorcentajeProf		DECIMAL(10,2);	 # Porcentaje Parametrizado Profesionistas
DECLARE Var_PorcentajeComSLoc	DECIMAL(10,2);	 # Porcentaje Parametrizado Comercial no Establecido
DECLARE Var_PorcentajeOtras		DECIMAL(10,2);	 # Porcentaje Parametrizado Otras Actividades
DECLARE Var_FechaAnterior  		DATE;            # Fecha un Dia Anterior
DECLARE Var_SalCapVig       	DECIMAL(14,2);   # Saldo Capital Vigente

DECLARE Var_SalCapAtr       	DECIMAL(14,2);   # Saldo Capital Atrasado
DECLARE Var_SalIntVig       	DECIMAL(14,2);	 # Saldo Interes Vigente
DECLARE Var_SalIntAtr       	DECIMAL(14,2);   # Saldo Interes Atrasado
DECLARE	Var_SalCapVen			DECIMAL(14,2);   # Saldo Capital Vencido
DECLARE Var_SalIntVen       	DECIMAL(14,2);   # Saldo Interes Vencido

DECLARE Var_SalTotCartera   	DECIMAL(14,2);   # Saldo Total de la Cartera de Credito
DECLARE Var_MontoCreditoTotal   DECIMAL(14,2);   # Monto de Credito Total

# Declaracion de Constantes
DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Entero_Cero			INT(11);
DECLARE	Decimal_Cero		DECIMAL(14,2);
DECLARE Fecha_Vacia			DATE;
DECLARE ParamSectorEco		INT(11);
DECLARE RefAgricultura		INT(11);
DECLARE RefAmaCasa			INT(11);
DECLARE RefArrendadores		INT(11);
DECLARE RefComerEstable		INT(11);
DECLARE RefDocentes			INT(11);
DECLARE RefEmpleados		INT(11);
DECLARE RefEmpresario		INT(11);
DECLARE RefEstudiantes		INT(11);
DECLARE RefOficios			INT(11);
DECLARE RefPensionados		INT(11);
DECLARE RefProfesionista	INT(11);
DECLARE RefComSinLocal		INT(11);
DECLARE RefOtras			INT(11);
DECLARE Rep_MontoSecEco     INT(11);
DECLARE Rep_SaldoSecEco		INT(11);
DECLARE Rep_Excel		    INT(11);
DECLARE Rep_CarteraCredito  INT(11);
DECLARE MovimientoCargo		CHAR(1);
DECLARE MovimientoAbono		CHAR(1);
DECLARE Mov_CapOrd          INT(11);
DECLARE Mov_CapAtr          INT(11);
DECLARE Mov_CapVen          INT(11);
DECLARE Mov_CapVNE          INT(11);
DECLARE Mov_IntOrd          INT(11);
DECLARE Mov_IntAtr          INT(11);
DECLARE Mov_IntVen          INT(11);
DECLARE Mov_IntPro          INT(11);
DECLARE Mov_IntMor          INT(11);
DECLARE Mov_IntMoratoVen	INT(11);
DECLARE DescGanAgrPesca     VARCHAR(50);
DECLARE DescAmaCasa    		VARCHAR(50);
DECLARE DescArrendadores    VARCHAR(50);
DECLARE DescComerEstab    	VARCHAR(50);
DECLARE DescDocentes    	VARCHAR(50);
DECLARE DescEmpleados    	VARCHAR(50);
DECLARE DescEmpresarios    	VARCHAR(50);
DECLARE DescEstudiantes    	VARCHAR(50);
DECLARE DescOficios     	VARCHAR(50);
DECLARE DescPensionados     VARCHAR(50);
DECLARE DescProfesionistas  VARCHAR(50);
DECLARE DescComerSinLocal   VARCHAR(50);
DECLARE DescOtraActividad   VARCHAR(50);

# Asignacion de Constantes
SET	Cadena_Vacia		:= '';				# Cadena Vacia
SET	Entero_Cero			:= 0;				# Entero Cero
SET	Decimal_Cero		:= 0.0;				# Decimal Cero
SET Fecha_Vacia			:= '1900-01-01';    # Fecha Vacia
SET ParamSectorEco   	:= 16;              # CatParamRiesgosID: Parametro Creditos por Sector Economico
SET RefAgricultura		:= 1;  				# Referencia: Agricultura, Ganaderia, Pesca
SET RefAmaCasa			:= 2;  				# Referencia: Ama de Casa
SET RefArrendadores		:= 3;  				# Referencia: Arrendadores
SET RefComerEstable		:= 4;  				# Referencia: Comerciantes Establecidos
SET RefDocentes			:= 5;  				# Referencia: Docentes
SET RefEmpleados		:= 6;				# Referencia: Empleados
SET RefEmpresario       := 7;				# Referencia: Empresarios
SET RefEstudiantes		:= 8;				# Referencia: Estudiantes
SET RefOficios			:= 9; 				# Referencia: Personas que desempeÃ±an algun Oficio
SET RefPensionados		:= 10;  			# Referencia: Pensionados
SET RefProfesionista	:= 11;  			# Referencia: Profesionistas
SET RefComSinLocal		:= 12;  			# Referencia: Comercial sin Local Establecido
SET RefOtras			:= 13;  			# Referencia: Otras Actividades
SET Rep_MontoSecEco		:= 1;               # Reporte: Monto de Cartera por Sector Economico
SET Rep_SaldoSecEco		:= 2;				# Reporte: Parametro de Porcentaje por Sector Economico
SET Rep_Excel		    := 3;				# Reporte: Porcentual por Sector Economico
SET Rep_CarteraCredito  := 4;               # Reporte: Saldo Cartera de Credito
SET MovimientoCargo     :='C';              # Naturaleza Movimiento: Cargo
SET MovimientoAbono     :='A';				# Naturaleza Movimiento: Abono
SET Mov_CapOrd          := 1;			    # Tipo de Movimiento: Capital Vigente
SET Mov_CapAtr          := 2;				# Tipo de Movimiento: Capital Atrasado
SET Mov_CapVen          := 3;				# Tipo de Movimiento: Capital Vencido
SET Mov_CapVNE          := 4;				# Tipo de Movimiento: Capital Vencido no Exigible
SET Mov_IntOrd          := 10;				# Tipo de Movimiento: Interes Ordinario
SET Mov_IntAtr          := 11;				# Tipo de Movimiento: Interes Atrasado
SET Mov_IntVen          := 12;				# Tipo de Movimiento: Interes Vencido
SET Mov_IntPro          := 14;				# Tipo de Movimiento: Interes Provisionado
SET Mov_IntMor          := 15;				# Tipo de Movimiento: Interes Moratorio
SET Mov_IntMoratoVen	:= 16;			    # Tipo de Movimiento: Interes Moratorio Vencido
SET DescGanAgrPesca     := 'AGRICULTURA, GANADERIA, PESCA Y SILVICULTURA';
SET DescAmaCasa    		:= 'AMAS DE CASA';
SET DescArrendadores    := 'ARRENDADORES';
SET DescComerEstab    	:= 'COMERCIANTES ESTABLECIDOS';
SET DescDocentes    	:= 'DOCENTES';
SET DescEmpleados    	:= 'EMPLEADOS';
SET DescEmpresarios    	:= 'EMPRESARIOS';
SET DescEstudiantes    	:= 'ESTUDIANTES';
SET DescOficios     	:= 'OFICIOS';
SET DescPensionados     := 'PENSIONADOS';
SET DescProfesionistas  := 'PROFESIONISTAS';
SET DescOtraActividad   := 'OTRAS ACTIVIDADES';

# Asignacion de Variables
SET Var_FechaAnterior 		:= (SELECT DATE_ADD(Par_FechaOperacion, INTERVAL -1 DAY));
SET Var_PorcentajeAgri   	:= (SELECT Porcentaje FROM PARAMUACIRIESGOS WHERE CatParamRiesgosID = ParamSectorEco AND ReferenciaID = RefAgricultura);
SET Var_PorcentajeAma   	:= (SELECT Porcentaje FROM PARAMUACIRIESGOS WHERE CatParamRiesgosID = ParamSectorEco AND ReferenciaID = RefAmaCasa);
SET Var_PorcentajeArre   	:= (SELECT Porcentaje FROM PARAMUACIRIESGOS WHERE CatParamRiesgosID = ParamSectorEco AND ReferenciaID = RefArrendadores);
SET Var_PorcentajeComEst   	:= (SELECT Porcentaje FROM PARAMUACIRIESGOS WHERE CatParamRiesgosID = ParamSectorEco AND ReferenciaID = RefComerEstable);

SET Var_PorcentajeDoc   	:= (SELECT Porcentaje FROM PARAMUACIRIESGOS WHERE CatParamRiesgosID = ParamSectorEco AND ReferenciaID = RefDocentes);
SET Var_PorcentajeEmple   	:= (SELECT Porcentaje FROM PARAMUACIRIESGOS WHERE CatParamRiesgosID = ParamSectorEco AND ReferenciaID = RefEmpleados);
SET Var_PorcentajeEmpre   	:= (SELECT Porcentaje FROM PARAMUACIRIESGOS WHERE CatParamRiesgosID = ParamSectorEco AND ReferenciaID = RefEmpresario);
SET Var_PorcentajeEst   	:= (SELECT Porcentaje FROM PARAMUACIRIESGOS WHERE CatParamRiesgosID = ParamSectorEco AND ReferenciaID = RefEstudiantes);
SET Var_PorcentajeOfi   	:= (SELECT Porcentaje FROM PARAMUACIRIESGOS WHERE CatParamRiesgosID = ParamSectorEco AND ReferenciaID = RefOficios);

SET Var_PorcentajePen   	:= (SELECT Porcentaje FROM PARAMUACIRIESGOS WHERE CatParamRiesgosID = ParamSectorEco AND ReferenciaID = RefPensionados);
SET Var_PorcentajeProf   	:= (SELECT Porcentaje FROM PARAMUACIRIESGOS WHERE CatParamRiesgosID = ParamSectorEco AND ReferenciaID = RefProfesionista);
SET Var_PorcentajeComSLoc   := (SELECT Porcentaje FROM PARAMUACIRIESGOS WHERE CatParamRiesgosID = ParamSectorEco AND ReferenciaID = RefComSinLocal);
SET Var_PorcentajeOtras   	:= (SELECT Porcentaje FROM PARAMUACIRIESGOS WHERE CatParamRiesgosID = ParamSectorEco AND ReferenciaID = RefOtras);


# ============ Saldo Total de la Cartera de Credito Vigente y Vencida  al Dia Anterior ======================
SELECT SUM(SalCapVigente), SUM(SalCapAtrasado), SUM(SalIntProvision + SalMoratorios),
	   SUM(SalIntAtrasado),SUM(SalCapVencido + SalCapVenNoExi),
	   SUM(SalIntVencido + SaldoMoraVencido)
	INTO Var_SalCapVig, Var_SalCapAtr, Var_SalIntVig,
		Var_SalIntAtr,	Var_SalCapVen, Var_SalIntVen
		FROM SALDOSCREDITOS
			WHERE FechaCorte = Var_FechaAnterior;

SET	Var_SalCapVig		:= IFNULL(Var_SalCapVig,Decimal_Cero);
SET Var_SalCapAtr		:= IFNULL(Var_SalCapAtr,Decimal_Cero);
SET Var_SalIntVig		:= IFNULL(Var_SalIntVig,Decimal_Cero);
SET Var_SalIntAtr		:= IFNULL(Var_SalIntAtr,Decimal_Cero);
SET Var_SalCapVen		:= IFNULL(Var_SalCapVen,Decimal_Cero);
SET Var_SalIntVen		:= IFNULL(Var_SalIntVen,Decimal_Cero);

SET Var_SalTotCartera   := Var_SalCapVig + Var_SalCapAtr + Var_SalIntVig + Var_SalIntAtr +
							Var_SalCapVen + Var_SalIntVen;

SET	Var_SalTotCartera	:= IFNULL(Var_SalTotCartera,Decimal_Cero);

# Reporte: Monto de Cartera por Sector Economico
IF(Par_NumRep = Rep_MontoSecEco) THEN
	DROP TABLE IF EXISTS TMPMONTOSECTORECO;
	CREATE TEMPORARY TABLE TMPMONTOSECTORECO(
		ReferenciaID		INT(11),
		Descripcion	        VARCHAR(100),
		Porcentaje          DECIMAL(10,2),
		MontoCredito		DECIMAL(14,2),
		Resultado	        DECIMAL(10,2),
		Diferencia	        DECIMAL(10,2));

	INSERT INTO TMPMONTOSECTORECO()
	SELECT ReferenciaID,Descripcion, Porcentaje,Decimal_Cero,Decimal_Cero,Decimal_Cero
	FROM PARAMUACIRIESGOS Par
	WHERE CatParamRiesgosID = ParamSectorEco;

	DROP TABLE IF EXISTS TMPSECTORECONOMICO;
	CREATE TEMPORARY TABLE TMPSECTORECONOMICO(
		ClienteID			INT(11),
		TipoMovCreID     	INT(11),
		ActividadBancoMX  	VARCHAR(15),
		ActividadINEGI   	INT(11),
		OcupacionID     	INT(11),
		MontoCargo	   	 	DECIMAL(14,2),
		MontoAbono      	DECIMAL(14,2),
        Descripcion         VARCHAR(100),
        MontoCredito        DECIMAL(14,2));

	INSERT INTO TMPSECTORECONOMICO()
	SELECT Cli.ClienteID, Mov.TipoMovCreID, Cli.ActividadBancoMX,Cli.ActividadINEGI,Cli.OcupacionID,
			IFNULL(CASE Mov.NatMovimiento WHEN MovimientoCargo THEN Mov.Cantidad ELSE Decimal_Cero END,Decimal_Cero)  AS MontoCargo,
			IFNULL(CASE Mov.NatMovimiento WHEN MovimientoAbono THEN Mov.Cantidad ELSE Decimal_Cero END,Decimal_Cero) AS MontoAbono,
            Cadena_Vacia, Decimal_Cero
		FROM CREDITOSMOVS Mov
		INNER JOIN CREDITOS Cre
			ON Mov.CreditoID = Cre.CreditoID
		INNER JOIN CLIENTES Cli
			ON Cre.ClienteID = Cli.ClienteID
				WHERE FechaOperacion = Var_FechaAnterior
			AND Mov.TipoMovCreID IN(Mov_CapVen,Mov_CapVNE,Mov_IntVen,Mov_IntMoratoVen,
			Mov_CapOrd, Mov_CapAtr,Mov_IntOrd,Mov_IntAtr,Mov_IntPro,Mov_IntMor);

	UPDATE TMPSECTORECONOMICO
	SET Descripcion = DescGanAgrPesca,
		MontoCredito = MontoCargo - MontoAbono
			WHERE ActividadINEGI IN (1001,1002,1004);

	UPDATE TMPSECTORECONOMICO
	SET Descripcion = DescAmaCasa,
		MontoCredito = MontoCargo - MontoAbono
			WHERE ActividadBancoMX = 8949888161
				AND ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
											8312019170,8949888162,8949888163,8415011251,
											8415011250)
				AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
									526, 813, 810,130,131,132,133,134,135,136,710,214,215);

	UPDATE TMPSECTORECONOMICO
	SET Descripcion = DescArrendadores,
		MontoCredito = MontoCargo - MontoAbono
			WHERE ActividadBancoMX = 8312019170
				AND ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
											8949888161,8949888162,8949888163,8415011251,
											8415011250)
				AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
										526, 813, 810,130,131,132,133,134,135,136,710,214,215);

	UPDATE TMPSECTORECONOMICO
	SET Descripcion = DescComerEstab,
		MontoCredito = MontoCargo - MontoAbono
			WHERE OcupacionID = 710
				AND ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
											8949888161,8312019170,8949888162,8949888163,
											8415011251,8415011250)
				AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
									526, 813, 810,130,131,132,133,134,135,136,214,215);

	UPDATE TMPSECTORECONOMICO
	SET Descripcion = DescDocentes,
		MontoCredito = MontoCargo - MontoAbono
			WHERE OcupacionID IN (130,131,132,133,134,135,136)
				AND ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
											8949888161,8312019170,8949888162,8949888163,
											8415011251,8415011250)
				AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
									526, 813, 810,710,214,215);

	UPDATE TMPSECTORECONOMICO
	SET Descripcion = DescEmpleados,
		MontoCredito = MontoCargo - MontoAbono
		  WHERE ActividadBancoMX IN (149907010,3999903060,8949903160,9411901190)
				AND ActividadBancoMX NOT IN (8949888161,8312019170,8949888162,8949888163,
											8415011251,8415011250)
				AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
									526, 813, 810,130,131,132,133,134,135,136,710,214,215);

	UPDATE TMPSECTORECONOMICO
	SET Descripcion = DescEmpresarios,
		MontoCredito = MontoCargo - MontoAbono
			WHERE OcupacionID IN (214,215)
				AND ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
											8949888161,8312019170,8949888162,8949888163,
											8415011251,8415011250)
				AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
									526, 813, 810,130,131,132,133,134,135,136,710);

	UPDATE TMPSECTORECONOMICO
	SET Descripcion = DescEstudiantes,
		MontoCredito = MontoCargo - MontoAbono
			WHERE ActividadBancoMX = 8949888162
				AND ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
											8949888161,8312019170,8949888163,8415011251,
											8415011250)
				AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
									526, 813, 810,130,131,132,133,134,135,136,710,214,215);

	UPDATE TMPSECTORECONOMICO
	SET Descripcion = DescOficios,
		MontoCredito = MontoCargo - MontoAbono
			WHERE OcupacionID IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525, 526, 813, 810)
				AND ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
											8949888161,8312019170,8949888162,8949888163,
											8415011251,8415011250)
				AND OcupacionID NOT IN (130,131,132,133,134,135,136,710,214,215);

	UPDATE TMPSECTORECONOMICO
	SET Descripcion = DescPensionados,
		MontoCredito = MontoCargo - MontoAbono
		  WHERE ActividadBancoMX = 8949888163
			AND ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
										8949888161,8312019170,8949888162,8415011251,
										8415011250)
			AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
									526, 813, 810,130,131,132,133,134,135,136,710,214,215);

	UPDATE TMPSECTORECONOMICO
	SET Descripcion = DescProfesionistas,
		MontoCredito = MontoCargo - MontoAbono
      WHERE ActividadBancoMX IN (8415011251,8415011250)
			AND ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
										8949888161,8312019170,8949888162,8949888163)
			AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
									526, 813, 810,130,131,132,133,134,135,136,710,214,215);

	UPDATE TMPSECTORECONOMICO
	SET Descripcion = DescOtraActividad,
		MontoCredito = MontoCargo - MontoAbono
			WHERE ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
											8949888161,8312019170,8949888162,8949888163,
											8415011251,8415011250)
			AND ActividadINEGI NOT IN (1001,1002,1004)
			AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
									526, 813, 810,130,131,132,133,134,135,136,710,214,215);

	DROP TABLE IF EXISTS TMPSUMAMONTOSECTOR;
	CREATE TEMPORARY TABLE TMPSUMAMONTOSECTOR(
        Descripcion         VARCHAR(100),
        MontoCredito        DECIMAL(14,2));
	INSERT INTO TMPSUMAMONTOSECTOR()
	SELECT Descripcion,SUM(MontoCredito)
		FROM TMPSECTORECONOMICO
			GROUP BY Descripcion;

	UPDATE TMPMONTOSECTORECO Tmp,
			TMPSUMAMONTOSECTOR Sum
		SET Tmp.MontoCredito = Sum.MontoCredito
			WHERE Tmp.Descripcion = Sum.Descripcion;

	UPDATE TMPMONTOSECTORECO
		SET  Resultado = IFNULL((CASE WHEN Var_SalTotCartera = Decimal_Cero THEN Decimal_Cero ELSE (MontoCredito / Var_SalTotCartera) END),Decimal_Cero) * 100;

	UPDATE TMPMONTOSECTORECO Tmp
		SET  Diferencia = Porcentaje - Resultado;

	SELECT SUM(MontoCredito) INTO Var_MontoCreditoTotal
		FROM TMPMONTOSECTORECO;

	SELECT Descripcion,FORMAT(MontoCredito,2) AS MontoCredito, Resultado,Porcentaje,Diferencia,
			FORMAT(Var_MontoCreditoTotal,2) AS Var_MontoCreditoTotal
			FROM TMPMONTOSECTORECO;

	DROP TABLE TMPMONTOSECTORECO;
	DROP TABLE TMPSUMAMONTOSECTOR;
	DROP TABLE TMPSECTORECONOMICO;

END IF;


# Reporte: Saldo de Cartera por Sector Economico
IF(Par_NumRep = Rep_SaldoSecEco) THEN
	DROP TABLE IF EXISTS TMPSALDOSECTORECO;
	CREATE TEMPORARY TABLE TMPSALDOSECTORECO(
		ReferenciaID		INT(11),
		Descripcion	        VARCHAR(100),
		Porcentaje          DECIMAL(10,2),
		SaldoCredito		DECIMAL(14,2),
		Resultado	        DECIMAL(10,2),
		Diferencia	        DECIMAL(10,2));

	INSERT INTO TMPSALDOSECTORECO()
	SELECT ReferenciaID,Descripcion, Porcentaje,Decimal_Cero,Decimal_Cero,Decimal_Cero
	FROM PARAMUACIRIESGOS Par
	WHERE CatParamRiesgosID = ParamSectorEco;

	DROP TABLE IF EXISTS TMPSECTORECONOMICO;
	CREATE TEMPORARY TABLE TMPSECTORECONOMICO(
		ClienteID			INT(11),
		ActividadBancoMX  	VARCHAR(15),
		ActividadINEGI   	INT(11),
		OcupacionID     	INT(11),
        Descripcion         VARCHAR(100),
        SaldoCredito        DECIMAL(14,2));

	INSERT INTO TMPSECTORECONOMICO()
	SELECT Cli.ClienteID, Cli.ActividadBancoMX,Cli.ActividadINEGI,Cli.OcupacionID,Cadena_Vacia,
		(Sal.SalCapVigente + Sal.SalCapAtrasado + Sal.SalIntProvision + Sal.SalMoratorios + Sal.SalIntAtrasado +
			Sal.SalCapVencido + Sal.SalCapVenNoExi + Sal.SalIntVencido + Sal.SaldoMoraVencido) AS SaldosCreditos
		FROM SALDOSCREDITOS Sal
		INNER JOIN CREDITOS Cre
			ON Sal.CreditoID = Cre.CreditoID
		INNER JOIN CLIENTES Cli
			ON Cre.ClienteID = Cli.ClienteID
				WHERE Sal.FechaCorte = Var_FechaAnterior;

	UPDATE TMPSECTORECONOMICO
		SET Descripcion = DescGanAgrPesca
				WHERE ActividadINEGI IN (1001,1002,1004);

	UPDATE TMPSECTORECONOMICO
	SET Descripcion = DescAmaCasa
			WHERE ActividadBancoMX = 8949888161
				AND ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
											8312019170,8949888162,8949888163,8415011251,
											8415011250)
				AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
									526, 813, 810,130,131,132,133,134,135,136,710,214,215);

	UPDATE TMPSECTORECONOMICO
	SET Descripcion = DescArrendadores
			WHERE ActividadBancoMX = 8312019170
				AND ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
											8949888161,8949888162,8949888163,8415011251,
											8415011250)
				AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
										526, 813, 810,130,131,132,133,134,135,136,710,214,215);

	UPDATE TMPSECTORECONOMICO
	SET Descripcion = DescComerEstab
			WHERE OcupacionID = 710
				AND ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
											8949888161,8312019170,8949888162,8949888163,
											8415011251,8415011250)
				AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
									526, 813, 810,130,131,132,133,134,135,136,214,215);

	UPDATE TMPSECTORECONOMICO
	SET Descripcion = DescDocentes
			WHERE OcupacionID IN (130,131,132,133,134,135,136)
				AND ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
											8949888161,8312019170,8949888162,8949888163,
											8415011251,8415011250)
				AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
									526, 813, 810,710,214,215);


	UPDATE TMPSECTORECONOMICO
	SET Descripcion = DescEmpleados
		  WHERE ActividadBancoMX IN (149907010,3999903060,8949903160,9411901190)
				AND ActividadBancoMX NOT IN (8949888161,8312019170,8949888162,8949888163,
											8415011251,8415011250)
				AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
									526, 813, 810,130,131,132,133,134,135,136,710,214,215);

	UPDATE TMPSECTORECONOMICO
	SET Descripcion = DescEmpresarios
			WHERE OcupacionID IN (214,215)
				AND ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
											8949888161,8312019170,8949888162,8949888163,
											8415011251,8415011250)
				AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
									526, 813, 810,130,131,132,133,134,135,136,710);

	UPDATE TMPSECTORECONOMICO
	SET Descripcion = DescEstudiantes
			WHERE ActividadBancoMX = 8949888162
				AND ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
											8949888161,8312019170,8949888163,8415011251,
											8415011250)
				AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
									526, 813, 810,130,131,132,133,134,135,136,710,214,215);


	UPDATE TMPSECTORECONOMICO
	SET Descripcion = DescOficios
			WHERE OcupacionID IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525, 526, 813, 810)
				AND ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
											8949888161,8312019170,8949888162,8949888163,
											8415011251,8415011250)
				AND OcupacionID NOT IN (130,131,132,133,134,135,136,710,214,215);

	UPDATE TMPSECTORECONOMICO
	SET Descripcion = DescPensionados
		  WHERE ActividadBancoMX = 8949888163
			AND ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
										8949888161,8312019170,8949888162,8415011251,
										8415011250)
			AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
									526, 813, 810,130,131,132,133,134,135,136,710,214,215);

	UPDATE TMPSECTORECONOMICO
	SET Descripcion = DescProfesionistas
      WHERE ActividadBancoMX IN (8415011251,8415011250)
			AND ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
										8949888161,8312019170,8949888162,8949888163)
			AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
									526, 813, 810,130,131,132,133,134,135,136,710,214,215);
	UPDATE TMPSECTORECONOMICO
	SET Descripcion = DescOtraActividad
			WHERE ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
											8949888161,8312019170,8949888162,8949888163,
											8415011251,8415011250)
			AND ActividadINEGI NOT IN (1001,1002,1004)
			AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
									526, 813, 810,130,131,132,133,134,135,136,710,214,215);

	DROP TABLE IF EXISTS TMPSUMASALDOSECTOR;
	CREATE TEMPORARY TABLE TMPSUMASALDOSECTOR(
        Descripcion         VARCHAR(100),
        SaldoCredito        DECIMAL(14,2));
	INSERT INTO TMPSUMASALDOSECTOR()
	SELECT Descripcion,SUM(SaldoCredito)
		FROM TMPSECTORECONOMICO
			GROUP BY Descripcion;

	UPDATE TMPSALDOSECTORECO Tmp,
			TMPSUMASALDOSECTOR Sum
		SET Tmp.SaldoCredito = Sum.SaldoCredito
			WHERE Tmp.Descripcion = Sum.Descripcion;

	UPDATE TMPSALDOSECTORECO
		SET  Resultado = IFNULL((CASE WHEN Var_SalTotCartera = Decimal_Cero THEN Decimal_Cero ELSE (SaldoCredito / Var_SalTotCartera) END),Decimal_Cero) * 100;

	UPDATE TMPSALDOSECTORECO Tmp
		SET  Diferencia = Porcentaje - Resultado;

	SELECT Descripcion,SaldoCredito,Resultado,Porcentaje,Diferencia
			FROM TMPSALDOSECTORECO;

	DROP TABLE TMPSALDOSECTORECO;
	DROP TABLE TMPSUMASALDOSECTOR;
	DROP TABLE TMPSECTORECONOMICO;

END IF;


# Reporte: Creditos por Sectores Economicos en Excel
IF(Par_NumRep = Rep_Excel) THEN
# ============== MONTO DE CARTERA DEL DIA ANTERIOR ===============
	DROP TABLE IF EXISTS TMPMONTOSECTORECO;
	CREATE TEMPORARY TABLE TMPMONTOSECTORECO(
		ReferenciaID		INT(11),
		Descripcion	        VARCHAR(100),
		Porcentaje          DECIMAL(10,2),
		MontoCredito		DECIMAL(14,2),
		Resultado	        DECIMAL(10,2),
		Diferencia	        DECIMAL(10,2));

	INSERT INTO TMPMONTOSECTORECO()
	SELECT ReferenciaID,Descripcion, Porcentaje,Decimal_Cero,Decimal_Cero,Decimal_Cero
	FROM PARAMUACIRIESGOS Par
	WHERE CatParamRiesgosID = ParamSectorEco;

	DROP TABLE IF EXISTS TMPMONTOSECTORECONOMICO;
	CREATE TEMPORARY TABLE TMPMONTOSECTORECONOMICO(
		ClienteID			INT(11),
		TipoMovCreID     	INT(11),
		ActividadBancoMX  	VARCHAR(15),
		ActividadINEGI   	INT(11),
		OcupacionID     	INT(11),
		MontoCargo	   	 	DECIMAL(14,2),
		MontoAbono      	DECIMAL(14,2),
        Descripcion         VARCHAR(100),
        MontoCredito        DECIMAL(14,2));

	INSERT INTO TMPMONTOSECTORECONOMICO()
	SELECT Cli.ClienteID, Mov.TipoMovCreID, Cli.ActividadBancoMX,Cli.ActividadINEGI,Cli.OcupacionID,
			IFNULL(CASE Mov.NatMovimiento WHEN MovimientoCargo THEN Mov.Cantidad ELSE Decimal_Cero END,Decimal_Cero)  AS MontoCargo,
			IFNULL(CASE Mov.NatMovimiento WHEN MovimientoAbono THEN Mov.Cantidad ELSE Decimal_Cero END,Decimal_Cero) AS MontoAbono,
            Cadena_Vacia, Decimal_Cero
		FROM CREDITOSMOVS Mov
		INNER JOIN CREDITOS Cre
			ON Mov.CreditoID = Cre.CreditoID
		INNER JOIN CLIENTES Cli
			ON Cre.ClienteID = Cli.ClienteID
				WHERE FechaOperacion = Var_FechaAnterior
			AND Mov.TipoMovCreID IN(Mov_CapVen,Mov_CapVNE,Mov_IntVen,Mov_IntMoratoVen,
			Mov_CapOrd, Mov_CapAtr,Mov_IntOrd,Mov_IntAtr,Mov_IntPro,Mov_IntMor);

	UPDATE TMPMONTOSECTORECONOMICO
	SET Descripcion = DescGanAgrPesca,
		MontoCredito = MontoCargo - MontoAbono
			WHERE ActividadINEGI IN (1001,1002,1004);

	UPDATE TMPMONTOSECTORECONOMICO
	SET Descripcion = DescAmaCasa,
		MontoCredito = MontoCargo - MontoAbono
			WHERE ActividadBancoMX = 8949888161
				AND ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
											8312019170,8949888162,8949888163,8415011251,
											8415011250)
				AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
									526, 813, 810,130,131,132,133,134,135,136,710,214,215);

	UPDATE TMPMONTOSECTORECONOMICO
	SET Descripcion = DescArrendadores,
		MontoCredito = MontoCargo - MontoAbono
			WHERE ActividadBancoMX = 8312019170
				AND ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
											8949888161,8949888162,8949888163,8415011251,
											8415011250)
				AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
										526, 813, 810,130,131,132,133,134,135,136,710,214,215);

	UPDATE TMPMONTOSECTORECONOMICO
	SET Descripcion = DescComerEstab,
		MontoCredito = MontoCargo - MontoAbono
			WHERE OcupacionID = 710
				AND ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
											8949888161,8312019170,8949888162,8949888163,
											8415011251,8415011250)
				AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
									526, 813, 810,130,131,132,133,134,135,136,214,215);

	UPDATE TMPMONTOSECTORECONOMICO
	SET Descripcion = DescDocentes,
		MontoCredito = MontoCargo - MontoAbono
			WHERE OcupacionID IN (130,131,132,133,134,135,136)
				AND ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
											8949888161,8312019170,8949888162,8949888163,
											8415011251,8415011250)
				AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
									526, 813, 810,710,214,215);

	UPDATE TMPMONTOSECTORECONOMICO
	SET Descripcion = DescEmpleados,
		MontoCredito = MontoCargo - MontoAbono
		  WHERE ActividadBancoMX IN (149907010,3999903060,8949903160,9411901190)
				AND ActividadBancoMX NOT IN (8949888161,8312019170,8949888162,8949888163,
											8415011251,8415011250)
				AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
									526, 813, 810,130,131,132,133,134,135,136,710,214,215);

	UPDATE TMPMONTOSECTORECONOMICO
	SET Descripcion = DescEmpresarios,
		MontoCredito = MontoCargo - MontoAbono
			WHERE OcupacionID IN (214,215)
				AND ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
											8949888161,8312019170,8949888162,8949888163,
											8415011251,8415011250)
				AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
									526, 813, 810,130,131,132,133,134,135,136,710);

	UPDATE TMPMONTOSECTORECONOMICO
	SET Descripcion = DescEstudiantes,
		MontoCredito = MontoCargo - MontoAbono
			WHERE ActividadBancoMX = 8949888162
				AND ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
											8949888161,8312019170,8949888163,8415011251,
											8415011250)
				AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
									526, 813, 810,130,131,132,133,134,135,136,710,214,215);

	UPDATE TMPMONTOSECTORECONOMICO
	SET Descripcion = DescOficios,
		MontoCredito = MontoCargo - MontoAbono
			WHERE OcupacionID IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525, 526, 813, 810)
				AND ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
											8949888161,8312019170,8949888162,8949888163,
											8415011251,8415011250)
				AND OcupacionID NOT IN (130,131,132,133,134,135,136,710,214,215);

	UPDATE TMPMONTOSECTORECONOMICO
	SET Descripcion = DescPensionados,
		MontoCredito = MontoCargo - MontoAbono
		  WHERE ActividadBancoMX = 8949888163
			AND ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
										8949888161,8312019170,8949888162,8415011251,
										8415011250)
			AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
									526, 813, 810,130,131,132,133,134,135,136,710,214,215);

	UPDATE TMPMONTOSECTORECONOMICO
	SET Descripcion = DescProfesionistas,
		MontoCredito = MontoCargo - MontoAbono
      WHERE ActividadBancoMX IN (8415011251,8415011250)
			AND ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
										8949888161,8312019170,8949888162,8949888163)
			AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
									526, 813, 810,130,131,132,133,134,135,136,710,214,215);

	UPDATE TMPMONTOSECTORECONOMICO
	SET Descripcion = DescOtraActividad,
		MontoCredito = MontoCargo - MontoAbono
			WHERE ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
											8949888161,8312019170,8949888162,8949888163,
											8415011251,8415011250)
			AND ActividadINEGI NOT IN (1001,1002,1004)
			AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
									526, 813, 810,130,131,132,133,134,135,136,710,214,215);

	DROP TABLE IF EXISTS TMPSUMAMONTOSECTOR;
	CREATE TEMPORARY TABLE TMPSUMAMONTOSECTOR(
        Descripcion         VARCHAR(100),
        MontoCredito        DECIMAL(14,2));
	INSERT INTO TMPSUMAMONTOSECTOR()
	SELECT Descripcion,SUM(MontoCredito)
		FROM TMPMONTOSECTORECONOMICO
			GROUP BY Descripcion;

	UPDATE TMPMONTOSECTORECO Tmp,
			TMPSUMAMONTOSECTOR Sum
		SET Tmp.MontoCredito = Sum.MontoCredito
			WHERE Tmp.Descripcion = Sum.Descripcion;

	UPDATE TMPMONTOSECTORECO
		SET  Resultado = IFNULL((CASE WHEN Var_SalTotCartera = Decimal_Cero THEN Decimal_Cero ELSE (MontoCredito / Var_SalTotCartera) END),Decimal_Cero) * 100;

	UPDATE TMPMONTOSECTORECO Tmp
		SET  Diferencia = Porcentaje - Resultado;


	DROP TABLE IF EXISTS TMPMONTOSECTORES;
	CREATE TEMPORARY TABLE TMPMONTOSECTORES(
		Descripcion	        VARCHAR(100),
		MontoCredito		DECIMAL(14,2),
		ResultadoMonto	    DECIMAL(10,2),
		PorcentajeMonto     DECIMAL(10,2),
		DiferenciaMonto	    DECIMAL(10,2));

	INSERT INTO TMPMONTOSECTORES()
	SELECT Descripcion,MontoCredito,Resultado,Porcentaje,Diferencia
			FROM TMPMONTOSECTORECO;

# ============== SALDOS DE CARTERA AL DIA ANTERIOR ===============
	DROP TABLE IF EXISTS TMPSALDOSECTORECO;
	CREATE TEMPORARY TABLE TMPSALDOSECTORECO(
		ReferenciaID		INT(11),
		Descripcion	        VARCHAR(100),
		Porcentaje          DECIMAL(10,2),
		SaldoCredito		DECIMAL(14,2),
		Resultado	        DECIMAL(10,2),
		Diferencia	        DECIMAL(10,2));

	INSERT INTO TMPSALDOSECTORECO()
	SELECT ReferenciaID,Descripcion, Porcentaje,Decimal_Cero,Decimal_Cero,Decimal_Cero
	FROM PARAMUACIRIESGOS Par
	WHERE CatParamRiesgosID = ParamSectorEco;

	DROP TABLE IF EXISTS TMPSALDOSECTORECONOMICO;
	CREATE TEMPORARY TABLE TMPSALDOSECTORECONOMICO(
		ClienteID			INT(11),
		ActividadBancoMX  	VARCHAR(15),
		ActividadINEGI   	INT(11),
		OcupacionID     	INT(11),
        Descripcion         VARCHAR(100),
        SaldoCredito        DECIMAL(14,2));

	INSERT INTO TMPSALDOSECTORECONOMICO()
	SELECT Cli.ClienteID, Cli.ActividadBancoMX,Cli.ActividadINEGI,Cli.OcupacionID,Cadena_Vacia,
		(Sal.SalCapVigente + Sal.SalCapAtrasado + Sal.SalIntProvision + Sal.SalMoratorios + Sal.SalIntAtrasado +
			Sal.SalCapVencido + Sal.SalCapVenNoExi + Sal.SalIntVencido + Sal.SaldoMoraVencido) AS SaldosCreditos
		FROM SALDOSCREDITOS Sal
		INNER JOIN CREDITOS Cre
			ON Sal.CreditoID = Cre.CreditoID
		INNER JOIN CLIENTES Cli
			ON Cre.ClienteID = Cli.ClienteID
				WHERE Sal.FechaCorte = Var_FechaAnterior;

	UPDATE TMPSALDOSECTORECONOMICO
		SET Descripcion = DescGanAgrPesca
				WHERE ActividadINEGI IN (1001,1002,1004);

	UPDATE TMPSALDOSECTORECONOMICO
	SET Descripcion = DescAmaCasa
			WHERE ActividadBancoMX = 8949888161
				AND ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
											8312019170,8949888162,8949888163,8415011251,
											8415011250)
				AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
									526, 813, 810,130,131,132,133,134,135,136,710,214,215);

	UPDATE TMPSALDOSECTORECONOMICO
	SET Descripcion = DescArrendadores
			WHERE ActividadBancoMX = 8312019170
				AND ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
											8949888161,8949888162,8949888163,8415011251,
											8415011250)
				AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
										526, 813, 810,130,131,132,133,134,135,136,710,214,215);

	UPDATE TMPSALDOSECTORECONOMICO
	SET Descripcion = DescComerEstab
			WHERE OcupacionID = 710
				AND ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
											8949888161,8312019170,8949888162,8949888163,
											8415011251,8415011250)
				AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
									526, 813, 810,130,131,132,133,134,135,136,214,215);

	UPDATE TMPSALDOSECTORECONOMICO
	SET Descripcion = DescDocentes
			WHERE OcupacionID IN (130,131,132,133,134,135,136)
				AND ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
											8949888161,8312019170,8949888162,8949888163,
											8415011251,8415011250)
				AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
									526, 813, 810,710,214,215);


	UPDATE TMPSALDOSECTORECONOMICO
	SET Descripcion = DescEmpleados
		  WHERE ActividadBancoMX IN (149907010,3999903060,8949903160,9411901190)
				AND ActividadBancoMX NOT IN (8949888161,8312019170,8949888162,8949888163,
											8415011251,8415011250)
				AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
									526, 813, 810,130,131,132,133,134,135,136,710,214,215);

	UPDATE TMPSALDOSECTORECONOMICO
	SET Descripcion = DescEmpresarios
			WHERE OcupacionID IN (214,215)
				AND ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
											8949888161,8312019170,8949888162,8949888163,
											8415011251,8415011250)
				AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
									526, 813, 810,130,131,132,133,134,135,136,710);

	UPDATE TMPSALDOSECTORECONOMICO
	SET Descripcion = DescEstudiantes
			WHERE ActividadBancoMX = 8949888162
				AND ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
											8949888161,8312019170,8949888163,8415011251,
											8415011250)
				AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
									526, 813, 810,130,131,132,133,134,135,136,710,214,215);


	UPDATE TMPSALDOSECTORECONOMICO
	SET Descripcion = DescOficios
			WHERE OcupacionID IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525, 526, 813, 810)
				AND ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
											8949888161,8312019170,8949888162,8949888163,
											8415011251,8415011250)
				AND OcupacionID NOT IN (130,131,132,133,134,135,136,710,214,215);

	UPDATE TMPSALDOSECTORECONOMICO
	SET Descripcion = DescPensionados
		  WHERE ActividadBancoMX = 8949888163
			AND ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
										8949888161,8312019170,8949888162,8415011251,
										8415011250)
			AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
									526, 813, 810,130,131,132,133,134,135,136,710,214,215);

	UPDATE TMPSALDOSECTORECONOMICO
	SET Descripcion = DescProfesionistas
      WHERE ActividadBancoMX IN (8415011251,8415011250)
			AND ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
										8949888161,8312019170,8949888162,8949888163)
			AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
									526, 813, 810,130,131,132,133,134,135,136,710,214,215);
	UPDATE TMPSALDOSECTORECONOMICO
	SET Descripcion = DescOtraActividad
			WHERE ActividadBancoMX NOT IN (149907010,3999903060,8949903160,9411901190,
											8949888161,8312019170,8949888162,8949888163,
											8415011251,8415011250)
			AND ActividadINEGI NOT IN (1001,1002,1004)
			AND OcupacionID NOT IN (140, 142, 143, 144, 145, 146, 521, 522, 523, 524, 525,
									526, 813, 810,130,131,132,133,134,135,136,710,214,215);

	DROP TABLE IF EXISTS TMPSUMASALDOSECTOR;
	CREATE TEMPORARY TABLE TMPSUMASALDOSECTOR(
        Descripcion         VARCHAR(100),
        SaldoCredito        DECIMAL(14,2));
	INSERT INTO TMPSUMASALDOSECTOR()
	SELECT Descripcion,SUM(SaldoCredito)
		FROM TMPSALDOSECTORECONOMICO
			GROUP BY Descripcion;

	UPDATE TMPSALDOSECTORECO Tmp,
			TMPSUMASALDOSECTOR Sum
		SET Tmp.SaldoCredito = Sum.SaldoCredito
			WHERE Tmp.Descripcion = Sum.Descripcion;

	UPDATE TMPSALDOSECTORECO
		SET  Resultado = IFNULL((CASE WHEN Var_SalTotCartera =  Decimal_Cero THEN Decimal_Cero ELSE (SaldoCredito / Var_SalTotCartera) END),Decimal_Cero) * 100;

	UPDATE TMPSALDOSECTORECO Tmp
		SET  Diferencia = Porcentaje - Resultado;


	DROP TABLE IF EXISTS TMPSALDOSECTORES;
	CREATE TEMPORARY TABLE TMPSALDOSECTORES(
		Descripcion	        VARCHAR(100),
		SaldoCredito		DECIMAL(14,2),
		ResultadoSaldo	    DECIMAL(10,2),
		PorcentajeSaldo     DECIMAL(10,2),
		DiferenciaSaldo	    DECIMAL(10,2));

	INSERT INTO TMPSALDOSECTORES()
	SELECT Descripcion,SaldoCredito,Resultado,Porcentaje,Diferencia
			FROM TMPSALDOSECTORECO;


SELECT Mon.Descripcion,			Mon.MontoCredito, 	Mon.ResultadoMonto,  	Mon.PorcentajeMonto,
		Mon.DiferenciaMonto,	Sal.SaldoCredito, 	Sal.ResultadoSaldo,		Sal.PorcentajeSaldo,
		Sal.DiferenciaSaldo
	FROM TMPMONTOSECTORES Mon
	INNER JOIN TMPSALDOSECTORES Sal
			WHERE Mon.Descripcion = Sal.Descripcion;

DROP TABLE TMPMONTOSECTORECO;
DROP TABLE TMPMONTOSECTORECONOMICO;
DROP TABLE TMPSUMAMONTOSECTOR;
DROP TABLE TMPMONTOSECTORES;

DROP TABLE TMPSALDOSECTORECO;
DROP TABLE TMPSALDOSECTORECONOMICO;
DROP TABLE TMPSUMASALDOSECTOR;
DROP TABLE TMPSALDOSECTORES;
END IF;

# Reporte: Saldos de Cartera de Credito
IF(Par_NumRep = Rep_CarteraCredito) THEN
# ============ Saldo Total de la Cartera de Credito Vigente y Vencida  al Dia Anterior ======================
SELECT SUM(SalCapVigente), SUM(SalCapAtrasado), SUM(SalIntProvision + SalMoratorios),
	   SUM(SalIntAtrasado),SUM(SalCapVencido + SalCapVenNoExi),
	   SUM(SalIntVencido + SaldoMoraVencido)
	INTO Var_SalCapVig, Var_SalCapAtr, Var_SalIntVig,
		Var_SalIntAtr,	Var_SalCapVen, Var_SalIntVen
		FROM SALDOSCREDITOS
			WHERE FechaCorte = Var_FechaAnterior;

SET	Var_SalCapVig		:= IFNULL(Var_SalCapVig,Decimal_Cero);
SET Var_SalCapAtr		:= IFNULL(Var_SalCapAtr,Decimal_Cero);
SET Var_SalIntVig		:= IFNULL(Var_SalIntVig,Decimal_Cero);
SET Var_SalIntAtr		:= IFNULL(Var_SalIntAtr,Decimal_Cero);
SET Var_SalCapVen		:= IFNULL(Var_SalCapVen,Decimal_Cero);
SET Var_SalIntVen		:= IFNULL(Var_SalIntVen,Decimal_Cero);

SET Var_SalTotCartera   := Var_SalCapVig + Var_SalCapAtr + Var_SalIntVig + Var_SalIntAtr +
							Var_SalCapVen + Var_SalIntVen;

SET	Var_SalTotCartera	:= IFNULL(Var_SalTotCartera,Decimal_Cero);
SELECT Var_SalTotCartera;
END IF;

END TerminaStore$$