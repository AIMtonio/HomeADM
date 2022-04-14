-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EXCEDENTERIESGOCOMUNPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EXCEDENTERIESGOCOMUNPRO`;DELIMITER $$

CREATE PROCEDURE `EXCEDENTERIESGOCOMUNPRO`(

# =====================================================================================
# --------------- STORED PARA INSERTAR LOS REGISTROS QUE PROCESAN --------------
#---------- EN EL MONITOR DE SOLICITUDES PARA LOS EXCENDENTES DE RIESGOS -------
# =====================================================================================
    Par_ClienteID			INT(11), 		-- Numero del Cliente con el que tiene relacion
    Par_CreditoID			BIGINT(12), 	-- Numero de Credito con el que tiene relacion

    Par_Salida    			CHAR(1),		-- Parametro de salida S= si, N= no
    INOUT Par_NumErr 		INT(11),		-- Parametro de salida numero de error
    INOUT Par_ErrMen  		VARCHAR(400),	-- Parametro de salida mensaje de error

	-- Parametros de Auditoria
    Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
    DECLARE Var_Consecutivo		VARCHAR(100);   	-- Variable consecutivo
	DECLARE Var_Control         VARCHAR(100);   	-- Variable de Control
	DECLARE FechaSis	        DATE;			   	-- Variable de Fecha del Sistema
    DECLARE Var_GrupoID			INT(11);			-- Variable que Indica el ID del Grupo
    DECLARE Var_Conta			INT(11);			-- Variable de Contador de Reg
    DECLARE Var_Cliente			INT(11);			-- Variable Cliente de Riesgo
    DECLARE Var_ConsecutivoID	INT(11);			-- Variable ConsecutivoID
    DECLARE Var_SaldoIntegrante	DOUBLE(14,2);		-- Variable de Saldo del Integrante
    DECLARE Var_SaldoGrupo      DOUBLE(14,2);       -- Variable de Saldo del Grupo




    -- DECLARACION DE CONSTANTES

	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI
    DECLARE Var_Procesado		CHAR(1);			-- Estatus si una solicitud ya fue procesada 'S'
	DECLARE Var_Estatus			CHAR(1);			-- Estatus si una soliciutd ya fue registrada 'R'
	DECLARE Var_Riesgo			CHAR(1);			-- Estatus si una soliciutd es de Riesgo Comun 'S'

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
    DECLARE Cons_SI 			CHAR(1);
    DECLARE Cons_NO 			CHAR(1);


    -- ASIGNACION DE CONSTANTES

	SET Cadena_Vacia        	:= '';				-- Constante Cadena Vacia
	SET Fecha_Vacia         	:= '1900-01-01';	-- Constante Fecha Vacia
	SET Entero_Cero         	:= 0;  				-- Constante Cero
	SET Decimal_Cero			:= 0.0;				-- Constate Decimal 0.00
	SET Salida_SI          		:= 'S';				-- Constante Salida SI

	SET Salida_NO           	:= 'N';				-- Constante Salida NO
	SET Cons_SI 				:= 'S';				-- Constante SI
	SET Cons_NO 				:= 'N';				-- Constante NO
    SET Var_Procesado			:= 'S';				-- Estatus Procesado
    SET Var_Estatus				:= 'R';				-- Estatus Registrado
    SET Var_Riesgo				:= 'S';				-- Estatus Riesgo


	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-EXCEDENTERIESGOCOMUNPRO');
			SET Var_Control := 'SQLEXCEPTION';
		END;

		SET FechaSis := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

		/* Se realiza consultas para verificar si existe el pivote como grupo o no */
        SET Var_ConsecutivoID := (SELECT ConsecutivoID FROM RIESGOCOMUNGRUPOS WHERE ClienteID = Par_ClienteID );
        SET Var_ConsecutivoID := IFNULL(Var_ConsecutivoID, Entero_Cero);

        IF (Var_ConsecutivoID = Entero_Cero ) THEN
        SET Var_Conta := (SELECT COUNT(*) FROM RIESGOCOMUNGRUPOS);
			INSERT INTO RIESGOCOMUNGRUPOS
            SELECT (Var_Conta + 1),     Par_ClienteID,		Par_EmpresaID,      Aud_Usuario,
                    Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,    	Aud_Sucursal,       Aud_NumTransaccion;
        END IF;

        SET Var_ConsecutivoID := (SELECT ConsecutivoID FROM RIESGOCOMUNGRUPOS WHERE ClienteID = Par_ClienteID );
		SET Var_Cliente := (SELECT ClienteID  FROM CREDITOS WHERE CreditoID = Par_CreditoID);

        INSERT INTO EXCEDENTERIESGOCOMUN
            SELECT Var_ConsecutivoID,		Cadena_Vacia,		CLI.ClienteID,			Par_CreditoID,	          FechaSis,
            CLI.NombreCompleto,
					CASE (CLI.TipoPersona)
						WHEN 'F' THEN 'FISICA'
                        WHEN 'M' THEN 'MORAL'
                        WHEN 'A' THEN 'FISICA'
					END AS TipoPersona,
					CASE (CLI.TipoPersona)
						WHEN 'F' THEN ''
						WHEN 'M' THEN CLI.RFCpm
                        WHEN 'A' THEN ''
					END AS RFC,
					CASE (CLI.TipoPersona)
						WHEN 'F' THEN CLI.CURP
                        WHEN 'M' THEN ''
                        WHEN 'A' THEN CLI.CURP
					END AS CURP,
                    Par_EmpresaID,      Aud_Usuario,		Aud_FechaActual,        Aud_DireccionIP,
                    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion
            FROM CLIENTES CLI
            WHERE CLI.ClienteID = Var_Cliente;


		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= CONCAT('Excedente de Riesgo Procesado Exitosamente' );
        SET Var_Control		:= '';


	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$