-- EMERGENTECRCBDESEMBCREDWSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EMERGENTECRCBDESEMBCREDWSPRO`;

DELIMITER $$
CREATE PROCEDURE `EMERGENTECRCBDESEMBCREDWSPRO`(
	-- === SP para realizar alta de creditos mediante el WS de Alta de Creditos de CREDICLUB =====
	 Par_FolioCarga				INT(11),			-- Folio de la Carga a Procesar
	
	Par_Salida					CHAR(1), 			-- Indica mensaje de Salida
	INOUT Par_NumErr			INT(11),			-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),		-- Descripcion de Error

	Par_EmpresaID		        INT(11),			-- Parametro de Auditoria
	Aud_Usuario			        INT(11),			-- Parametro de Auditoria
	Aud_FechaActual		  		DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal				INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore:BEGIN
	-- Declaracion de Variables
	DECLARE Var_Contador				BIGINT(20);					-- Contador para las iteraciones
	DECLARE Var_CantRegistros			BIGINT(20);					-- Cantidad de registros para las iteraciones
	DECLARE Var_CrcbDesCredWSID 		BIGINT(20);					-- ID del la tabla de carga masiva de creditos
	DECLARE Var_FechaCarga				DATETIME;					-- Fecha de Carga
	DECLARE Var_FolioCarga				INT(11);					-- Folio de carga
	DECLARE Var_CreditoID				BIGINT(10);					-- ID del credito generado
	DECLARE Var_GrupoID         		INT(11);					-- ID del Grupo del Cliente
	DECLARE Var_NumErr					INT(11);					-- Numero de Error
	DECLARE Var_ErrMen					VARCHAR(400);				-- Descripcion de Error
	DECLARE Var_FechaSistema			DATE;						-- Fecha del Sistema
	DECLARE Var_PolizaID				BIGINT(20);					-- ID de la Poliza contable
	DECLARE Error_Key					INT(11);
	
    -- Declaracion de Constantes
    DECLARE Entero_Cero         		INT(11);					-- Entero Cero
    DECLARE Cadena_Vacia        		CHAR(1);					-- Cadena Vacia
	DECLARE Decimal_Cero	    		DECIMAL(12,2);				-- DECIMAL Cero
	DECLARE Fecha_Vacia         		DATE;						-- Fecha Vacia
    DECLARE SalidaSI            		CHAR(1);					-- El Store SI genera una Salida
    DECLARE SalidaNO            		CHAR(1);					-- El Store NO genera una Salida
    DECLARE Entero_Uno					INT(11);					-- Entero con valor uno
    DECLARE Var_SP						VARCHAR(30);				-- Nombre del SP con error
    DECLARE Var_ConceptoID				INT(11);					-- Concepto Contable de Desembolso de Credito (CONCEPTOSCONTA)
    DECLARE Var_Concepto 				VARCHAR(30);				-- Descripcion del concepto Contable de Desembolso de Credito (CONCEPTOSCONTA)
    DECLARE Var_TipoPoliza				CHAR(1);					-- Tipo de Poliza Automatica
   
    -- Asignacion de Constantes
	SET Entero_Cero						:= 0;						-- Entero Cero
	SET Cadena_Vacia					:= '';						-- Cadena Vacia
	SET Decimal_Cero	    			:=  0.00;   				-- DECIMAL Cero
	SET Fecha_Vacia						:= '1900-01-01';			-- Fecha Vacia
    SET SalidaSI           				:= 'S';        				-- El Store SI genera una Salida
    SET	SalidaNO 	   	   				:= 'N';	      				-- El Store NO genera una Salida
    SET Entero_Uno						:= 1;						-- Entero con valor uno
    SET Var_ConceptoID					:= 50;						-- Concepto Contable de Desembolso de Credito (CONCEPTOSCONTA)
    SET Var_Concepto					:= 'DESEMBOLSO DE CREDITO'; -- Descripcion del concepto Contable de Desembolso de Credito (CONCEPTOSCONTA)
    SET Var_TipoPoliza					:= 'A';						-- Tipo de Poliza automatica

	ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = '999';
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-EMERGENTECRCBDESEMBCREDWSPRO');
		END;
		
		
		SET @IDNum := 0;
		
		-- Consulto la fecha del sistema para la poliza
		SELECT 		FechaSistema
			INTO 	Var_FechaSistema
			FROM PARAMETROSSIS;
		
		DELETE FROM TMP_CS_CRCBDESCREDINDGRUPWS;
		
		INSERT INTO TMP_CS_CRCBDESCREDINDGRUPWS 
			SELECT 	(@IDNum := @IDNum + 1),	     CrcbDesCredIndGrupWSID,			FechaCarga,				FolioCarga,				CreditoID,
                    GrupoID
				FROM CS_CRCBDESCREDINDGRUPWSPRO
				WHERE FolioCarga = Par_FolioCarga;
				
				
		SELECT MIN(NumRegistro),		MAX(NumRegistro)
			INTO Var_Contador,			Var_CantRegistros
			FROM TMP_CS_CRCBDESCREDINDGRUPWS;
			


		WHILE Var_Contador <= Var_CantRegistros AND Var_Contador > Entero_Cero  DO
			Ejecucion:BEGIN
				SET Var_CrcbDesCredWSID := NULL;
				SET Var_FechaCarga	:= NULL;
				SET Var_FolioCarga := NULL;
				SET Var_GrupoID := NULL;
				SET Var_CreditoID := NULL;
				SET Var_PolizaID := NULL;
				SET Error_Key := Entero_Cero;
				SET Par_NumErr := Entero_Cero;
				SET Par_ErrMen := '';
				SET Var_SP := NULL;
			
				SELECT 		CrcbDesCredIndGrupWSID,		FechaCarga,			FolioCarga,				CreditoID,			GrupoID
					INTO 	Var_CrcbDesCredWSID,		Var_FechaCarga,		Var_FolioCarga,			Var_CreditoID,		Var_GrupoID
					FROM TMP_CS_CRCBDESCREDINDGRUPWS
					WHERE NumRegistro = Var_Contador;
					
				IF(Var_CreditoID < Entero_Cero) THEN
					SET Par_NumErr := 1;
					SET Par_ErrMen := 'El numero de Credito es Incorrecto.';
					SET Var_SP := 'EMERGENTECRCBDESEMBCREDWSPRO';
					LEAVE Ejecucion;
				END IF;
				
				IF(Var_GrupoID < Entero_Cero) THEN
					SET Par_NumErr :=2;
					SET Par_ErrMen := 'El numero de Grupo es Incorrecto.';
					SET Var_SP := 'EMERGENTECRCBDESEMBCREDWSPRO';
					LEAVE Ejecucion;
				END IF;
				
				IF(Par_EmpresaID <= Entero_Cero) THEN
					SET Par_NumErr :=3;
					SET Par_ErrMen := 'El ID de la Empresa es Incorrecto.';
					SET Var_SP := 'EMERGENTECRCBDESEMBCREDWSPRO';
					LEAVE Ejecucion;
				END IF;
				
				IF(Aud_Usuario <= Entero_Cero) THEN
					SET Par_NumErr :=4;
					SET Par_ErrMen := 'El ID del Usuario es Incorrecto.';
					SET Var_SP := 'EMERGENTECRCBDESEMBCREDWSPRO';
					LEAVE Ejecucion;
				END IF;
				
				IF(Aud_Sucursal <= Entero_Cero) THEN
					SET Par_NumErr :=5;
					SET Par_ErrMen := 'El ID de la Sucursal es Incorrecto.';
					SET Var_SP := 'EMERGENTECRCBDESEMBCREDWSPRO';
					LEAVE Ejecucion;
				END IF;
				
				CALL TRANSACCIONESPRO(Aud_NumTransaccion);
				
				CALL MAESTROPOLIZAALT(
						Var_PolizaID,			Par_EmpresaID,				Var_FechaSistema,		Var_TipoPoliza,			Var_ConceptoID,
						Var_Concepto,			SalidaNO,					Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
						Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion
					);
					
					
				IF(IFNULL(Var_PolizaID, Entero_Cero) <= Entero_Cero) THEN
					SET Par_NumErr := 1;
					SET Par_ErrMen := 'Error al intentar crear la poliza contable.';
					SET Var_SP := 'MAESTROPOLIZAALT';
					LEAVE Ejecucion;
				END IF;

				-- Iniciamos transaccion
				START TRANSACTION;
				transaccion: BEGIN
					DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
					DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
					DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
					DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;
						
					CALL CRCBDESCREDINDGRUPWSPRO (
							Var_CreditoID,			Var_GrupoID,				Var_PolizaID,			SalidaNO,				Par_NumErr,
							Par_ErrMen,				Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
							Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion
						);
						
			
				END transaccion;
				IF Error_Key = 0 && Par_NumErr = Entero_Cero THEN
					COMMIT;
				ELSE
					ROLLBACK;
				END IF;
				
			END Ejecucion;
			
			IF Error_Key = 0 && Par_NumErr = Entero_Cero THEN
				INSERT INTO BITEXITODESCREDINDGRUWS (
								FechaCarga,				FolioCarga,				CreditoID,				GrupoID,				CrcbDesCredIndGrupWSID,
								PolizaID,				FechaDesembolso
						)
						SELECT 	Var_FechaCarga,			Var_FolioCarga,			Var_CreditoID,			Var_GrupoID,			Var_CrcbDesCredWSID,
								Var_PolizaID,			Aud_FechaActual;
			ELSE
				IF(Par_NumErr = Entero_Cero ) THEN
					SET Par_ErrMen := Error_Key;
				END IF;
			
				INSERT INTO BITERRORDESCREDINDGRUWS (
								FechaCarga,				FolioCarga,				CreditoID,				GrupoID,				CrcbDesCredIndGrupWSID,
								Mensaje,				Codigo,					SP
						)
						SELECT 	Var_FechaCarga,			Var_FolioCarga,			Var_CreditoID,			Var_GrupoID,			Var_CrcbDesCredWSID,
								Par_ErrMen,				Par_NumErr,				'CRCBDESCREDINDGRUPWSPRO';
			END IF;
			
			-- Incrementamos el contador
			SET Var_Contador := Var_Contador + 1;
		END WHILE;
		
		SET Par_NumErr      := Entero_Cero;
		SET Par_ErrMen      := 'Proceso masivo de desembolsos finalizado.';
	END ManejoErrores;

     IF(Par_Salida = SalidaSI)THEN
		SELECT 	Par_NumErr		AS codigoRespuesta,
				Par_ErrMen     	AS mensajeRespuesta;
	END IF;

END TerminaStore$$