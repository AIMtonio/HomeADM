-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLSALDOSUCURSALCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLSALDOSUCURSALCON`;DELIMITER $$

CREATE PROCEDURE `SOLSALDOSUCURSALCON`(
# ==================================================================
# ----- SP PARA CONSULTAR INFORMACION DE SALDOS POR SUCURSAL -------
# ==================================================================
	Par_UsuarioID			INT(11),
	Par_SucursalID			INT(11),
	Par_NumCon				TINYINT UNSIGNED,

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_FechaSistema	DATE;			-- Almacena la Fecha del sistema
	DECLARE Var_DiaHabilAnt 	DATE;			-- Dia Habil Anterior
	DECLARE Var_CanCreDesem		INT(11);		-- Cantidad Creditos Por Desembolsar
	DECLARE Var_MonCreDesem		DECIMAL(14,2);	-- Monto Creditos Por Desembolsar
	DECLARE Var_CanInverVenci 	INT(11);		-- Cantidad Inversiones Por Vencer Hoy
	DECLARE Var_MonInverVenci	DECIMAL(14,2);	-- Monto Inversiones Por Vencer Hoy
	DECLARE Var_CanChequeEmi	INT(11);		-- Cantidad Cheques Emitidos en Transito
	DECLARE Var_MonChequeEmi	DECIMAL(14,2);	--  Monto Cheques Emitidos en Transito
	DECLARE Var_CanChequeIntReA	INT(11);		-- Cantidad Cheques Internos Recibidos Dia Anterior
	DECLARE Var_MonChequeIntReA DECIMAL(14,2);	-- Monto Cheques Internos Recibidos Dia Anterior
	DECLARE Var_CanChequeIntRe	INT(11);		-- Cantidad Cheques Internos Recibidos Hoy
	DECLARE Var_MonChequeIntRe  DECIMAL(14,2);	-- Monto Cheques Internos Recibidos Hoy
	DECLARE Var_SaldosCP		DECIMAL(14,2);	-- Saldos en Caja Principal
	DECLARE Var_SaldosCA		DECIMAL(14,2);	-- Saldos en Cajas Atencion
	DECLARE Var_ExisteSol		INT(11);


	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);		-- Almacena Cadena Vacia
	DECLARE	Fecha_Vacia			DATE;			-- Almacena Fecha Vacia 1900-01-01
	DECLARE NumDiasAnt			INT(1);			-- Numero de dias Anteriores 1
	DECLARE	Entero_Cero			INT(11);			-- Almacena un Cero
	DECLARE Decimal_Cero		DECIMAL(14,2);	-- Almacena un Cero
	DECLARE	Con_Principal		INT(11);			-- Almacena el valor de la Consulta Principal
	DECLARE Cre_Autorizado		CHAR(1);		-- Estatus Credito Autorizado
	DECLARE Inv_Vigente			CHAR(1);		-- Estatus Inversion Vigente
	DECLARE Che_Emitido			CHAR(1);		-- Estatus Cheque Emitido
	DECLARE Abo_Interno			CHAR(1);		-- Tipo Cuenta AbonoCheques Interna
	DECLARE Abo_Aplicado		CHAR(1);		-- Estatus AbonoCheques Aplicado
	DECLARE Caja_Principal		VARCHAR(3);		-- Tipo Caja Principal de Sucursal
	DECLARE Caja_Atencion		VARCHAR(3);		-- Tipo Caja Atencion al Publico
	DECLARE EMITIDO_EN			CHAR(1);		-- Almacena donde fue emitido el cheque V ventanilla T Tesoreria
	DECLARE Var_FechaAnterior   DATE;			-- Fecha 10 días antes de la solicitud para considerar en la consulta de creditos

	-- Asignacion de Constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET NumDiasAnt			:= 1;
	SET	Entero_Cero			:= 0;
	SET Decimal_Cero		:= 0;
	SET	Con_Principal		:= 1;
	SET Cre_Autorizado		:= 'A';
	SET Inv_Vigente			:= 'N';
	SET Che_Emitido			:= 'E';
	SET Abo_Interno			:= 'I';
	SET Abo_Aplicado		:= 'A';
	SET Caja_Principal		:= 'CP';
	SET Caja_Atencion		:= 'CA';
	SET EMITIDO_EN			:= 'V';

	SELECT Sol.SolSaldoSucursalID
		INTO Var_ExisteSol
	FROM SOLSALDOSUCURSAL Sol
	INNER JOIN PARAMETROSSIS Par ON Sol.FechaSolicitud = Par.FechaSistema
								AND Sol.UsuarioID = Par_UsuarioID
								AND Sol.SucursalID = Par_SucursalID
	LIMIT 1;


	IF(Par_NumCon = Con_Principal) THEN

		IF (Var_ExisteSol > Entero_Cero) THEN
			SELECT	CanCreDesem,	 MonCreDesem,	 	CanInverVenci,		 MonInverVenci,		 CanChequeEmi,
					MonChequeEmi, 	 CanChequeIntReA, 	MonChequeIntReA, 	 CanChequeIntRe, 	 MonChequeIntRe,
					SaldosCP, 		 SaldosCA, 			MontoSolicitado, 	 Comentarios
				FROM SOLSALDOSUCURSAL
			   WHERE SolSaldoSucursalID = Var_ExisteSol;
		ELSE
			SELECT FechaSistema INTO Var_FechaSistema	FROM PARAMETROSSIS;
			SET Var_FechaSistema := IFNULL(Var_FechaSistema,Fecha_Vacia);

			SET Var_DiaHabilAnt := FUNCIONDIAHABILANT(Var_FechaSistema , NumDiasAnt, Par_EmpresaID);
			SET Var_FechaAnterior 	:= (SELECT DATE_ADD(Var_FechaSistema, INTERVAL -10 DAY));


			#  Cantidad y Monto Creditos Por Desembolsar
			SELECT COUNT(CreditoID), SUM(MontoCredito)  INTO Var_CanCreDesem, Var_MonCreDesem
				 FROM CREDITOS
				WHERE Estatus = Cre_Autorizado
				  AND SucursalID = Par_SucursalID
                  AND FechaAutoriza <= Var_FechaSistema AND FechaAutoriza > Var_FechaAnterior;
			SET Var_CanCreDesem := IFNULL(Var_CanCreDesem,Entero_Cero);
			SET Var_MonCreDesem := IFNULL(Var_MonCreDesem,Decimal_Cero);

			# Inversiones Por Vencer Hoy

			SELECT  	COUNT(I.InversionID), SUM(I.Monto)
				INTO	Var_CanInverVenci, Var_MonInverVenci
				FROM 	INVERSIONES I
						INNER JOIN CLIENTES C ON I.ClienteID=C.ClienteID AND C.SucursalOrigen=Par_SucursalID
				WHERE I.Estatus = Inv_Vigente
				AND I.FechaVencimiento =Var_FechaSistema;


			SET Var_CanInverVenci := IFNULL(Var_CanInverVenci,Entero_Cero);
			SET Var_MonInverVenci := IFNULL(Var_MonInverVenci,Decimal_Cero);

			#Cheques Emitidos en Transito
			SELECT 		COUNT(Monto), SUM(Monto) INTO Var_CanChequeEmi, Var_MonChequeEmi
				FROM 	CHEQUESEMITIDOS
				WHERE 	Estatus = Che_Emitido
				AND 	SucursalID = Par_SucursalID;
			SET Var_CanChequeEmi := IFNULL(Var_CanChequeEmi,Entero_Cero);
			SET Var_MonChequeEmi := IFNULL(Var_MonChequeEmi,Decimal_Cero);

			# Cheques Internos Recibidos Dia Anterior
			SELECT 		COUNT(ChequeSBCID), SUM(Monto) INTO Var_CanChequeIntReA, Var_MonChequeIntReA
				FROM 	ABONOCHEQUESBC
				WHERE 	TipoCtaCheque = Abo_Interno
				AND 	Estatus = Abo_Aplicado
				AND 	SucursalID = Par_SucursalID
		       	AND 	FechaCobro = Var_DiaHabilAnt;
			SET Var_CanChequeIntReA := IFNULL(Var_CanChequeIntReA,Entero_Cero);
			SET Var_MonChequeIntReA := IFNULL(Var_MonChequeIntReA,Decimal_Cero);

			#Cheques Internos Recibidos Hoy
			SELECT 		COUNT(ChequeSBCID), SUM(Monto) INTO Var_CanChequeIntRe, Var_MonChequeIntRe
				FROM 	ABONOCHEQUESBC
				WHERE 	TipoCtaCheque = Abo_Interno
				AND 	Estatus = Abo_Aplicado
				AND 	SucursalID = Par_SucursalID
				AND		FechaCobro = Var_FechaSistema;
			SET Var_CanChequeIntRe := IFNULL(Var_CanChequeIntRe,Entero_Cero);
			SET Var_MonChequeIntRe := IFNULL(Var_MonChequeIntRe,Decimal_Cero);

			# Saldos en Caja Principal
			SELECT 		SUM(SaldoEfecMN) INTO Var_SaldosCP
				FROM 	CAJASVENTANILLA
				WHERE 	TipoCaja = Caja_Principal
				AND  	SucursalID = Par_SucursalID;
			SET Var_SaldosCP := IFNULL(Var_SaldosCP,Decimal_Cero);

			#Saldos en Cajas Atencion
			SELECT	SUM(SaldoEfecMN) INTO Var_SaldosCA
				FROM CAJASVENTANILLA
				WHERE TipoCaja = Caja_Atencion
				AND SucursalID = Par_SucursalID;
			SET Var_SaldosCA := IFNULL(Var_SaldosCA,Decimal_Cero);

			SELECT
					Var_CanCreDesem AS CanCreDesem, 		Var_MonCreDesem AS MonCreDesem,
					Var_CanInverVenci AS CanInverVenci, 	Var_MonInverVenci AS MonInverVenci,
					Var_CanChequeEmi AS CanChequeEmi, 		Var_MonChequeEmi AS MonChequeEmi,
					Var_CanChequeIntReA AS CanChequeIntReA, Var_MonChequeIntReA AS MonChequeIntReA,
					Var_CanChequeIntRe AS CanChequeIntRe, Var_MonChequeIntRe AS MonChequeIntRe,
					Var_SaldosCP AS SaldosCP, 				Var_SaldosCA AS SaldosCA,
					Cadena_Vacia AS MontoSolicitado,		Cadena_Vacia AS Comentarios;
		END IF;
	END IF;


END TerminaStore$$