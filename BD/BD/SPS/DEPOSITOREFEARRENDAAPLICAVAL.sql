-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEPOSITOREFEARRENDAAPLICAVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `DEPOSITOREFEARRENDAAPLICAVAL`;DELIMITER $$

CREATE PROCEDURE `DEPOSITOREFEARRENDAAPLICAVAL`(
	--  SP QUE REGISTRA EL DEPOSITO REFERENCIADO DEL ARRENDAMIENTO*/
	Par_DepRefereID		BIGINT,       	-- FOLIO DE CARGA A PROCESAR
	Par_FolioCargaID	BIGINT,       	-- FOLIO DE CARGA A PROCESAR DETALLE
	Par_Salida			CHAR(1),      	-- INDICA SI EXISTE O NO UNA SALIDA
	INOUT Par_NumErr	INT(11),      	-- NUMERO DE ERROR
	INOUT Par_ErrMen	VARCHAR(400),   -- MENSAJE DE ERROR

	Aud_EmpresaID		INT(11),      	-- PARAMETRO DE AUDITORIA
	Aud_Usuario			INT(11),      	-- PARAMETRO DE AUDITORIA
	Aud_FechaActual		DATETIME,     	-- PARAMETRO DE AUDITORIA
	Aud_DireccionIP		VARCHAR(15),	-- PARAMETRO DE AUDITORIA
	Aud_ProgramaID		VARCHAR(50),    -- PARAMETRO DE AUDITORIA

	Aud_Sucursal		INT(11),      	-- PARAMETRO DE AUDITORIA
	Aud_NumTransaccion	BIGINT(20)		-- PARAMETRO DE AUDITORIA
  )
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Entero_Cero				INT(11);		-- CERO
	DECLARE Decimal_Cero			DECIMAL(14,2);	-- DECIMAL CERO
	DECLARE Cadena_Vacia			CHAR(1);		-- CADENA VACIA
	DECLARE Est_NoAplicar			CHAR(1);		-- ESTATUS NO APLICAR
	DECLARE Est_Aplicar				CHAR(1);		-- ESTATUS APLICAR
	DECLARE Var_SI					CHAR(1);		-- VALOR SI
	DECLARE Est_Generado			CHAR(1);		-- ESTATUS GENERADO


	-- Declaracion de Variables
	DECLARE Var_ArrendaID   		BIGINT(12);		-- ID ARRENDMAIENTO
	DECLARE Par_MontoMov    		DECIMAL(14,2);	-- MONTO MOVIMIENTO
	DECLARE Var_PagoIni     		DECIMAL(14,2);	-- PAGO INICIAL
	DECLARE Var_TotalPagoIni  		DECIMAL(14,2);	-- TOTAL DE PAGO
	DECLARE Var_TotalExigible  		DECIMAL(14,2);	-- TotalExigible
	DECLARE Var_ReferenciaMov 		VARCHAR(40);	-- REFERENCIA MOVIMIENTO
	DECLARE Var_Estatus     		CHAR(1);		-- ESTATUS
	DECLARE Var_EstatusArre   		CHAR(2);		-- ESTATUS ARRENDAMIENTO
	DECLARE Var_Control     		VARCHAR(50);	-- CONTROL
	DECLARE Par_Consecutivo   		VARCHAR(50);	-- VALOR CONSECUTIVO
	DECLARE Var_FechaSistema 		DATE;			-- FECHA DE SISTEMA
	DECLARE Var_IVASucurs			DECIMAL(8, 4);	-- IVA aplicado al arrendamiento

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0;					-- CERO
	SET Decimal_Cero    	:= 0;					-- DECIMAL CERO
	SET Cadena_Vacia    	:= '';					-- CADENA VACIA
	SET Est_NoAplicar   	:= 'N';					-- ESTATUS NO APLICAR
	SET Est_Aplicar     	:= 'A';					-- ESTATUS APLICAR
	SET Var_SI        		:= 'S';					-- VALOR SI
	SET Est_Generado    	:= 'G';					-- ESTATUS GENERADO

	-- Asignacion de Variables
	SET Aud_FechaActual		:= CURRENT_TIMESTAMP(); -- PARAMETRO DE AUDITORIA
	SET Var_Control			:= Cadena_Vacia;

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 'Disculpe las molestias que esto le ocasiona. REF: SP-DEPOSITOREFEARRENDAAPLICAVAL');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		SET Var_FechaSistema  := (SELECT FechaSistema FROM PARAMETROSSIS);

	  	SELECT    ReferenciaMov,		IFNULL(MontoMov,Entero_Cero)
	    	INTO  Var_ReferenciaMov,	Par_MontoMov
			FROM DEPOSITOREFEARRENDA
				WHERE   DepRefereID   = Par_DepRefereID
				AND  FolioCargaID  = Par_FolioCargaID;


	    SELECT    ArrendaID,		TotalPagoInicial,	Estatus
			INTO  Var_ArrendaID,	Var_PagoIni,		Var_EstatusArre
				FROM ARRENDAMIENTOS
				WHERE ArrendaID = Var_ReferenciaMov;

		SET Par_MontoMov		:= IFNULL(Par_MontoMov, Entero_Cero);
		SET Var_ReferenciaMov	:= IFNULL(Var_ReferenciaMov, Entero_Cero);
		SET Var_EstatusArre		:= IFNULL(Var_EstatusArre, Est_Generado);
		SET Var_ArrendaID		:= IFNULL(Var_ArrendaID, Entero_Cero);


		INSERT INTO TMPDEPOARRENDA(
			DepRefereID,		FolioCargaID,   	MontoMov,			ReferenciaMov,		EmpresaID,
			Usuario,			FechaActual,    	DireccionIP,    	ProgramaID,			Sucursal,
			NumTransaccion
		)VALUES(
			Par_DepRefereID,  	Par_FolioCargaID, 	Par_MontoMov,   	Var_ReferenciaMov,  Aud_EmpresaID,
			Aud_Usuario,    	Aud_FechaActual,  	Aud_DireccionIP,  	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion
		);

		SET Var_TotalPagoIni  := (SELECT SUM(MontoMov) FROM DEPOSITOREFEARRENDA WHERE NumTransaccion = Aud_NumTransaccion AND  ReferenciaMov = Var_ReferenciaMov);
		SET Var_TotalPagoIni  := IFNULL(Var_TotalPagoIni,Entero_Cero);

		IF(Var_EstatusArre = Est_Aplicar)THEN
			IF(Var_TotalPagoIni >= Var_PagoIni)THEN
				SET Var_Estatus   := Est_Aplicar;
			ELSE
				SET Var_Estatus   := Est_NoAplicar;
			END IF;
		ELSE
			IF(Var_EstatusArre != Est_Generado)THEN
				SET Var_Estatus   := Est_Aplicar;
			END IF;
		END IF;


		UPDATE TMPDEPOARRENDA SET
			Estatus = Var_Estatus
		WHERE   DepRefereID   = Par_DepRefereID
			AND  FolioCargaID  = Par_FolioCargaID;

	  	-- Deposito referenciado Validado Exitosamente
		SET Par_NumErr      := 000;
		SET Par_ErrMen      := CONCAT("Deposito Referenciado Validado Exitosamente");
	END ManejoErrores;

	-- SI LA SALIDA ES SI DEVUELVE EL MENSAJE DE EXITO
	IF (Par_Salida = Var_SI) THEN
	    SELECT  Par_NumErr,
				Par_ErrMen,
				Var_Control,
				Par_Consecutivo;
	END IF;

END TerminaStore$$