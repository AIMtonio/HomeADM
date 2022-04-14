-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MOVSANTGASTOSREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `MOVSANTGASTOSLIS`;
DELIMITER $$


CREATE PROCEDURE `MOVSANTGASTOSLIS`(
	Par_TipoOperacion	 	BIGINT,			-- El tipo de gasto
	Par_Naturaleza		    CHAR,			-- Naturaleza: Salida  "S" /Entrada "E"
	Par_Sucursal          	INT,			-- Sucusar ID
	Par_CajaID				INT,			-- Caja ID
    Par_FechaInicial		DATE,			-- Fecha Inicial
    Par_FechaFinal			DATE,			-- Fecha Final
	Par_NumLis				INT,			-- Numero de listado

	Aud_EmpresaID			INT,			-- Auditoria
    Aud_Usuario		    	INT,			-- Auditoria
	Aud_FechaActual			DATETIME,		-- Auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Auditoria
	Aud_ProgramaID		    VARCHAR(50),	-- Auditoria
	Aud_Sucursal		    INT,			-- Auditoria
	Aud_NumTransaccion		BIGINT			-- Auditoria


	)

TerminaStore: BEGIN

-- Declaracion de constantes
DECLARE Entero_Cero     	INT;		-- Entero cero
DECLARE EstatusVigente   	CHAR(1);	-- Estatus Vigente
DECLARE EstatusVencido   	CHAR(1);	-- Estatus vencido
DECLARE EstatusActivas   	CHAR(1);	-- Estatus Activas
DECLARE EstatusBloqueadas   CHAR(1);	-- Estatus Estatus Bloqueadas
DECLARE Cadena_Vacia		CHAR(1);	-- Cadena vacia
DECLARE Lis_Principal		TINYINT;	-- Consulta principal
DECLARE Lis_Anticipos		TINYINT;	-- Lista de anticipos
DECLARE Lis_Gastos			TINYINT;	-- Lista de gastos
DECLARE Var_NatSalidaCaja	CHAR(1);	-- Naturaleza Salida de Caja
DECLARE Var_NatEntradaCaja	CHAR(1);	-- Naturaleza Entrada a Caja
DECLARE Efectivo 			CHAR(1);		-- Efectivo
DECLARE DescEfectivo 		VARCHAR(10);	-- Descripcion de Efectivo
DECLARE Cheque 				CHAR(1);			-- Cheque
DECLARE DescCheque 			VARCHAR(10);		-- Descripcion de Cheque

-- Variables
DECLARE Var_FechaActual		DATE;		-- Fecha actual del Sistema
DECLARE Fecha_Vacia			DATE;		-- Fecha Vacia

-- Asignacion de constantes
SET Entero_Cero      		:= 0;		-- Entero cero
SET EstatusVigente   		:='V';		-- Estatus Vigente
SET EstatusVencido   		:='B';		-- Estatus vencido
SET EstatusActivas   		:='A';		-- Estatus Activas
SET EstatusBloqueadas   	:='B';		-- Estatus Estatus Bloqueadas
SET Cadena_Vacia			:='';		-- Cadena vacia
SET Lis_Principal			:= 1;		-- List principal
SET Lis_Anticipos			:= 2;		-- Lista de anticipos
SET Lis_Gastos				:= 3;		-- Lista de gastos
SET Var_NatSalidaCaja		:='S';		-- Naturaleza Salida de Caja
SET Var_NatEntradaCaja		:='E';		-- Naturaleza Entrada a Caja
SET Efectivo 				:='E';		-- Efectivo
SET DescEfectivo 			:='EFECTIVO';	-- Descripcion de Efectivo
SET Cheque 					:='C';			-- Cheque
SET DescCheque 				:='CHEQUE';		-- Descripcion de Cheque
SET Fecha_Vacia				:='1900-01-01';	-- Fecha vacia

SET Par_FechaInicial 		:= IFNULL(Par_FechaInicial, Fecha_Vacia);
SET Par_FechaFinal 			:= IFNULL(Par_FechaFinal, Fecha_Vacia);

IF(Par_NumLis = Lis_Principal) THEN
	SELECT 	CajaID,		Fecha,		MontoOpe,		FormaPago,		Naturaleza,		
			EmpleadoID
			FROM MOVSANTGASTOS WHERE CajaID = Par_CajaID;
END IF;

-- En sesion con Ediberto y personal de Pluriza se establece que la entrada de efectivo es un Anticipo
IF(Par_NumLis = Lis_Anticipos) THEN
    SELECT 		FechaSistema
        INTO 	Var_FechaActual
        FROM PARAMETROSSIS;
			
	SELECT 	MOV.CajaID,		MOV.Fecha,		MOV.MontoOpe,		MOV.FormaPago,		MOV.Naturaleza,		
			MOV.EmpleadoID,	TIP.Descripcion,
			IF(MOV.FormaPago = Efectivo, DescEfectivo, IF(MOV.FormaPago = Cheque, DescCheque, Cadena_Vacia)) AS DescFormaPago
			FROM MOVSANTGASTOS MOV
			INNER JOIN TIPOSANTGASTOS TIP ON MOV.TipoOperacion = TIP.TipoAntGastoID
			WHERE MOV.CajaID = Par_CajaID 
				AND MOV.Fecha >= IF(Par_FechaInicial = Fecha_Vacia, Var_FechaActual, Par_FechaInicial)
				AND MOV.Fecha <= IF(Par_FechaFinal = Fecha_Vacia, Var_FechaActual, Par_FechaFinal)
				AND MOV.Naturaleza = Var_NatEntradaCaja;
END IF;

-- En sesion con Ediberto y personal de Pluriza se establece que la salida de efectivo es un Gasto
IF(Par_NumLis = Lis_Gastos) THEN
    SELECT 		FechaSistema
        INTO 	Var_FechaActual
        FROM PARAMETROSSIS;
			
	SELECT 	MOV.CajaID,		MOV.Fecha,		MOV.MontoOpe,		MOV.FormaPago,		MOV.Naturaleza,		
			MOV.EmpleadoID, TIP.Descripcion,
			IF(MOV.FormaPago = Efectivo, DescEfectivo, IF(MOV.FormaPago = Cheque, DescCheque, Cadena_Vacia)) AS DescFormaPago
			FROM MOVSANTGASTOS MOV
			INNER JOIN TIPOSANTGASTOS TIP ON MOV.TipoOperacion = TIP.TipoAntGastoID
			WHERE MOV.CajaID = Par_CajaID 
				AND MOV.Fecha >= IF(Par_FechaInicial = Fecha_Vacia, Var_FechaActual, Par_FechaInicial)
				AND MOV.Fecha <= IF(Par_FechaFinal = Fecha_Vacia, Var_FechaActual, Par_FechaFinal)
				AND MOV.Naturaleza = Var_NatSalidaCaja;
END IF;


END TerminaStore$$ 
