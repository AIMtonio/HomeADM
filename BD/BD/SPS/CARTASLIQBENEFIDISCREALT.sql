-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARTASLIQBENEFIDISCREALT
DELIMITER ;
DROP PROCEDURE IF EXISTS CARTASLIQBENEFIDISCREALT;


DELIMITER $$

CREATE PROCEDURE CARTASLIQBENEFIDISCREALT(
    -- SP de Alta de Informacion de las Intrucciones de Dispersion de un Credito cuando hay una modificacion de Cartas de Liquidacion
	Par_SolicitudCreditoID	BIGINT(20),		-- Número de Solicitud

	Par_Salida				CHAR(1),		-- Tipo de Salida S.- Si N.- No
	INOUT Par_NumErr		INT(11),		-- Control de Errores: Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Control de Errores: Descripcion del Error

	Aud_EmpresaID			INT(11),		-- Parametro de Auditoria
	Aud_Usuario				INT(11),		-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal			INT(11),		-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de Auditoria
)

TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_SolicitudCre 	INT;			-- Variable de conteo de solicitudes
    DECLARE ContadorAux         INT(11);        -- Contador de Ciclos
    DECLARE NumRegistros        INT(11);        -- Numero de Registros por ciclo
    DECLARE Var_TipoDispersion  CHAR(1);        -- Tipo de Dispersion ID
    DECLARE Var_Beneficiario    VARCHAR(200);   -- Nombre del Beneficiario
    DECLARE Var_CuentaCLABE     VARCHAR(20);    -- Numero de Cuenta para Dispersion
    DECLARE Var_MontoDispersion DECIMAL(12,2);	-- Monto de dispersion
    DECLARE Var_PermiteModificar INT(11);		-- Indica el nivel de datos que se pueden modicar 1.- Permiter todo en Nuevos, 2.- Permite Monto en externas, 3.- No permite modificar nada para internas
    DECLARE Var_MontoCartas     DECIMAL(12,2);  -- Monto de las Cartas Internas y Externas
    DECLARE Var_MontoSolicitud  DECIMAL(12,2);  -- Monto de la Solicitud sin Comisiones

    -- Declaracion de Constantes
	DECLARE Entero_Cero			INT;			-- Constante Entero cero
	DECLARE Decimal_Cero		DECIMAL(12,2);	-- Constante Decimal cero
	DECLARE Var_Control			VARCHAR(100);	-- Variable de control
	DECLARE Var_SalidaSI		CHAR(1);		-- Constante de SI
	DECLARE Var_SalidaNO		CHAR(1);		-- Constante de NO
	DECLARE Cadena_Vacia		CHAR(1);		-- Constante de vacio
	DECLARE Var_TipoDisp		INT;			-- Variable para evaluar el Tipos de Dispersion

    DECLARE Con_ModExternas		INT;			-- Constante Modifica Internas
	DECLARE Con_ModInternas		INT;			-- Constante Modifica Internas
    DECLARE Var_NoAplica		CHAR(1);	-- Constante No Aplica
	DECLARE Con_CartaInter		CHAR(1);		-- Tipo Carta Internas
	DECLARE Var_Dispersiones	VARCHAR(100);	-- Tipo de Dispersión S .- SPEI, C .- Cheque O .- Orden de Pago , E.- Efectivo, T.- TRAN. SANTANDER, N.- No Aplica
	-- Inicialización de constantes
	SET Entero_Cero			:= 0;				-- Constante entero cero
	SET Decimal_Cero		:= 0.0;				-- Constante DECIMAL cero
	SET Var_SalidaSI		:= 'S';				-- Constante de SI
	SET Var_SalidaNO		:= 'N';				-- Constante de NO
    SET Cadena_Vacia        := '';              -- Cadena Vacia

    SET Con_ModExternas		:= 2;				-- Constante Modifica Internas
	SET Con_ModInternas		:= 3;				-- Constante Modifica Externas
	SET Var_NoAplica		:= 'N';		-- Constante No Aplica
	SET Con_CartaInter		:= 'I';				-- Tipo Carta Internas
	SET Var_Dispersiones	:= 'S,C,O,E,T,N'; 	-- Tipo de Dispersión S .- SPEI, C .- Cheque O .- Orden de Pago , E.- Efectivo, T.- TRAN. SANTANDER, N.- No Aplica.

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-CARTASLIQBENEFIDISCREALT');

			SET Var_Control:= 'sqlException';
		END;

        SET Var_Beneficiario = (SELECT NombreCompleto FROM CLIENTES WHERE ClienteID = 1);
        SET Var_Beneficiario    := IFNULL(Var_Beneficiario, Cadena_Vacia);

 		IF(Par_SolicitudCreditoID = Entero_Cero) THEN
			SET Par_NumErr  := 010;
			SET Par_ErrMen  := 'La Solicitud de Credito no es Valida.' ;
			SET Var_Control := 'solicitudCreditoID';
			LEAVE ManejoErrores;
		END IF;


        -- Eliminacion de Registros de Tabla Pivote
        DELETE FROM REGBENEFICDISPERSIONCRE
            WHERE  SolicitudCreditoID = Par_SolicitudCreditoID AND NumTransaccion = Aud_NumTransaccion;



        SET @Contador := 0;
			-- Se realiza el Insert de las Cartas Externas
		INSERT INTO REGBENEFICDISPERSIONCRE(
			RegistroID,			SolicitudCreditoID,		TipoDispersion,		Beneficiario,		CuentaCLABE,
			MontoDispersion,	PermiteModificar,		EmpresaID,			UsuarioID,			FechaActual,
			DireccionIP,		ProgramaID,				Sucursal,			NumTransaccion
		)
		SELECT
			(@Contador := @Contador + 1),
            CONS.SolicitudCreditoID,		CAS.TipoDispersionCasa,			CAS.NombreCasaCom,			CAS.CuentaCLABE,
			ASI.Monto,						Con_ModExternas,				Aud_EmpresaID,				Aud_Usuario,              Aud_FechaActual,
			Aud_DireccionIP,		        Aud_ProgramaID,				    Aud_Sucursal,			    Aud_NumTransaccion
        FROM CONSOLIDACIONCARTALIQ		AS CONS
        INNER JOIN ASIGCARTASLIQUIDACION	AS ASI ON CONS.SOLICITUDCREDITOID	= ASI.SOLICITUDCREDITOID
        INNER JOIN CASASCOMERCIALES		AS CAS ON ASI.CasaComercialID		= CAS.CasaComercialID
        WHERE ASI.SolicitudCreditoID 		= Par_SolicitudCreditoID;


		-- Se realiza el Insert de las Cartas Internas
		INSERT INTO REGBENEFICDISPERSIONCRE(
			RegistroID,			SolicitudCreditoID,		TipoDispersion,		Beneficiario,		CuentaCLABE,
			MontoDispersion,	PermiteModificar,		EmpresaID,			UsuarioID,			FechaActual,
			DireccionIP,		ProgramaID,				Sucursal,			NumTransaccion
		)
		SELECT
            (@Contador := @Contador + 1),
            LIQ.SolicitudCreditoID,		Var_NoAplica,		Var_Beneficiario,		Cadena_Vacia,
			CDET.MontoLiquidar,			Con_ModInternas,	Aud_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,			Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion
        FROM CONSOLIDACIONCARTALIQ			AS LIQ
        INNER JOIN CONSOLIDACARTALIQDET		AS LDET	ON LIQ.ConsolidaCartaID	= LDET.ConsolidaCartaID AND LDET.TIPOCARTA = Con_CartaInter
        INNER JOIN CARTALIQUIDACION			AS Cliq	ON LDET.CartaLiquidaID	= Cliq.CartaLiquidaID
        INNER JOIN CARTALIQUIDACIONDET		AS CDET ON Cliq.CartaLiquidaID	= CDET.CartaLiquidaID
        WHERE	LIQ.SolicitudCreditoID	= Par_SolicitudCreditoID;


        SET ContadorAux := 1;
        SET NumRegistros := (SELECT COUNT(*)
                                FROM REGBENEFICDISPERSIONCRE
                                WHERE  SolicitudCreditoID = Par_SolicitudCreditoID AND NumTransaccion = Aud_NumTransaccion);
        WHILE(ContadorAux<=NumRegistros)DO

            SELECT TipoDispersion,          Beneficiario,           CuentaCLABE,             MontoDispersion,
                    PermiteModificar
            INTO
                    Var_TipoDispersion,		Var_Beneficiario,		Var_CuentaCLABE,		Var_MontoDispersion,
                    Var_PermiteModificar
            FROM REGBENEFICDISPERSIONCRE
            WHERE RegistroID = ContadorAux
                AND NumTransaccion = Aud_NumTransaccion;

			SELECT FIND_IN_SET(Var_TipoDispersion,Var_Dispersiones) INTO Var_TipoDisp;

			IF(Var_TipoDisp = Entero_Cero) THEN
				SET Var_TipoDispersion = Var_NoAplica;
			END IF;

            CALL BENEFICDISPERSIONCREALT(
				Par_SolicitudCreditoID,     Var_TipoDispersion,		Var_Beneficiario,		Var_CuentaCLABE,	Var_MontoDispersion,
				Var_PermiteModificar, 		Var_SalidaNO,		    Par_NumErr,				Par_ErrMen,			Aud_EmpresaID,
				Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,	    Aud_ProgramaID,     Aud_Sucursal,
                Aud_NumTransaccion
			);

            IF Par_NumErr <> Entero_Cero THEN
				LEAVE ManejoErrores;
			END IF;

            SET ContadorAux := ContadorAux + 1;

        END WHILE;

        SELECT SUM(MontoDispersion)
        INTO Var_MontoCartas
        FROM REGBENEFICDISPERSIONCRE
            WHERE  SolicitudCreditoID = Par_SolicitudCreditoID AND NumTransaccion = Aud_NumTransaccion;

        SELECT
				CASE ForCobroComAper WHEN "D" THEN Sol.MontoSolici -(ROUND((Sol.MontoPorComAper + Sol.IVAComAper),2))
									 WHEN "F" THEN Sol.MontoSolici -(ROUND((Sol.MontoPorComAper + Sol.IVAComAper),2))
					ELSE Sol.MontoSolici
				END AS MontoSolici
        INTO Var_MontoSolicitud
		FROM SOLICITUDCREDITO Sol
		WHERE Sol.SolicitudCreditoID = Par_SolicitudCreditoID;

        SET Var_MontoSolicitud := IFNULL(Var_MontoSolicitud, Decimal_Cero);

        -- Eliminacion de Registros de Tabla Pivote
        DELETE FROM REGBENEFICDISPERSIONCRE
            WHERE  SolicitudCreditoID = Par_SolicitudCreditoID AND NumTransaccion = Aud_NumTransaccion;

        -- Si el monto de Cartas se Excede del Monto de Solicitud
        IF(Var_MontoCartas > Var_MontoSolicitud) THEN
            SET	Par_ErrMen	:= CONCAT('Detalle de consolidacion Agregado Exitosamente: ', CONVERT(Par_SolicitudCreditoID, CHAR), ' No olvides Actualizar el Nuevo Monto de la Solicitud con respecto al nuevo Monto de las Cartas');
        ELSE
            SET	Par_ErrMen	:= CONCAT('Detalle de consolidacion Agregado Exitosamente: ', CONVERT(Par_SolicitudCreditoID, CHAR));
        END IF;

        SET		Par_NumErr	:= 0;
        SET		Var_Control	:= 'solicitudCreditoID';

END ManejoErrores;

	IF(Par_Salida = Var_SalidaSI) THEN
		SELECT  Par_NumErr				AS NumErr,
				Par_ErrMen				AS ErrMen,
				Var_Control				AS control,
				Par_SolicitudCreditoID	AS consecutivo;/*Enviar siempre en exito el numero de Solicitud*/
	END IF;

END TerminaStore$$