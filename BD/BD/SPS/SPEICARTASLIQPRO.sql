-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEICARTASLIQPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEICARTASLIQPRO`;
DELIMITER $$

CREATE PROCEDURE `SPEICARTASLIQPRO`(
/* SP QUE REALIZA EL PROCESO DE SPEI POR CARTA DE LIQUIDACION */
	Par_CreditoID		        BIGINT(20), 	-- ID del Credito
    Par_Monto                   DECIMAL(14,2),  -- Monto correspondiente al Credito

	Par_Salida           		CHAR(1),		-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr     		INT(11),		-- Numero de Error
	INOUT Par_ErrMen     		VARCHAR(400),	-- Mensaje de Error
    /* Parametros de Auditoria */
	Par_EmpresaID				INT(11),        -- Parametros de Auditoria
	Aud_Usuario					INT(11),        -- Parametros de Auditoria
	Aud_FechaActual				DATETIME,       -- Parametros de Auditoria
	Aud_DireccionIP				VARCHAR(15),    -- Parametros de Auditoria
	Aud_ProgramaID				VARCHAR(50),    -- Parametros de Auditoria
	Aud_Sucursal				INT(11),        -- Parametros de Auditoria
	Aud_NumTransaccion			BIGINT(20)      -- Parametros de Auditoria
)
TerminaStore: BEGIN

    -- Declaracion de Constantes
    DECLARE	Var_Control             CHAR(25);           -- Var Control del Manejo de Errores
    DECLARE Var_FolioEnvio		    BIGINT(20);			-- Variable para obtener el folio de envio
    DECLARE Var_ClaveRastreo	    VARCHAR(30);		-- Variable para obtener la clave de rastreo
    DECLARE Var_CuentaAhoID         BIGINT(12);			-- Cuenta de Ahorro
    DECLARE Var_ClabeOrdenante		VARCHAR(20);		-- Variable para obtener la cable de la cuenta ordenante
    DECLARE Var_NombreOrdenante		VARCHAR(100);		-- Variable para obtener el nombre del ordenante
    DECLARE Var_RFCOrdenante		VARCHAR(18);		-- Variable para obtener el rfc del ordenante
    DECLARE Var_MonedaID            INT(11);            -- Variable de Moneda ID
    DECLARE Var_ComisionTrans	    DECIMAL(16,2);		-- Variable para almacenar la comision de tranferencia
    DECLARE Var_ComisionIVA		    DECIMAL(16,2);		-- Variable para almacenar le IVA de comision
    DECLARE Var_TotalCargoCuenta	DECIMAL(18,2);		-- Variable para almacenar el cargo total
    DECLARE Var_InstitRecep		    INT(5);				-- Variable para obtener la institucion receptora
    DECLARE VarCuentaCLABE          VARCHAR(18);        -- Cuenta CLABE
    DECLARE Var_NombreBenefi		VARCHAR(100);		-- Variable para obtener el nombre del beneficiario
    DECLARE Var_RFCBenefi			VARCHAR(100);		-- Variable para obtener el rfc del beneficiario
    DECLARE Var_FechaSinGuion		VARCHAR(7);			-- Variable para almacenar la fecha sin guiones
    DECLARE Var_ReferenciaNum		INT(7);				-- Variable para almacenar la referencia numerica del envio SPEI
    DECLARE Var_UsuEnvioSPEI		VARCHAR(30);		-- Variable para almacenar el usuario de envio SPEI
    DECLARE Var_CasaCom             BIGINT(11);            -- Variable casa Comercial
    DECLARE Var_MontoCarta          DECIMAL(14, 2);     -- Monto a desembolsar
    DECLARE Var_SoliciCredID		BIGINT(20);         -- Variable Solicitud de Credito
    DECLARE Var_NumCartas           INT(11);            -- Variable Numero de Cartas de Liq
    DECLARE Var_Conta               INT(11);            -- Variable Contador
    DECLARE Var_MontoFinal          DECIMAL(16,2);      -- Variable Monto Final para el proceso de SPEI


    -- Declaracion de Constantes
    DECLARE	Cadena_Vacia		VARCHAR(1);
    DECLARE	Fecha_Vacia			DATE;
    DECLARE	Entero_Cero			INT(11);
	DECLARE	Entero_Uno			INT(11);
    DECLARE Decimal_Cero		DECIMAL(12,2);
    DECLARE	SalidaSI        	CHAR(1);
    DECLARE	SalidaNO        	CHAR(1);
    DECLARE Var_TipoPagoTercer	INT(1);			    -- Tipo pago Tercero a Tercero del catalogo TIPOSPAGOSPEI
    DECLARE Var_TipoCuentaOrd	INT(2);			    -- Tipo cuenta cable del catalogo TIPOSCUENTASPEI
    DECLARE Var_ConceptoPago	VARCHAR(40);	    -- Concepto del pago SPEI
    DECLARE Var_AreaBanco		INT(1);			    -- Area emite banco SPEI
    DECLARE Var_OrigenOperVent	CHAR(1);		    -- Origen operacion ventanilla
    DECLARE Var_BloqueoID		INT(11);			-- ID de Bloqueo referente a la tabla de BLOQUEOS
    DECLARE Act_EstatusDesemPen	INT(11);		    -- Actualiza el estatus a P) Pendiente cuando el SPEI es por desembolso
    DECLARE Var_TipoCuentaBen	INT(2);				-- Variable para obtener el tipo cuenta del beneficiario
    DECLARE Var_FechaSistema	DATE;               -- Fecha de Sistema
    DECLARE Est_Activo          CHAR(1);            -- Estatus Activo
    DECLARE Var_SPEI            CHAR(1);            -- Tipo de Dispersion SPEI 'S'


    -- Asignacion de Constantes
    SET Cadena_Vacia			:= '';				-- Cadena vacia
    SET Fecha_Vacia				:= '1900-01-01';	-- Fecha vacia
    SET Entero_Cero				:= 0;				-- Entero Cero
    SET Decimal_Cero			:= 0.00;			-- DECIMAL Cero
	SET Entero_Uno				:= 1;				-- Entero Uno
    SET	SalidaSI        		:= 'S';				-- Salida Si
    SET	SalidaNO        		:= 'N'; 			-- Salida No
    SET Var_TipoPagoTercer		:= 1;			    -- Tipo pago Tercero a Tercero del catalogo TIPOSPAGOSPEI
    SET Var_TipoCuentaOrd		:= 40;			    -- Tipo cuenta cable del catalogo TIPOSCUENTASPEI
    SET Var_ConceptoPago		:= 'DESEMBOLSO DE CREDITO';	 -- Concepto del pago SPEI
    SET Var_AreaBanco			:= 8;			-- Area emite banco SPEI
    SET Var_OrigenOperVent		:= 'V';			-- Origen operacion ventanilla
	SET Act_EstatusDesemPen		:= 11;			-- Actualiza el estatus a P) Pendiente cuando el SPEI es por desembolso
    SET Var_TipoCuentaBen       := 40;
    SET Var_FechaSistema 	    := (SELECT FechaSistema FROM PARAMETROSSIS);
    SET Est_Activo              := 'A';
    SET Var_SPEI                := 'S';


ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SPEICARTASLIQPRO');
			SET Var_Control:= 'sqlException' ;
		END;

	IF(Par_CreditoID = Entero_Cero) THEN
		SET Par_NumErr := 001;
		SET Par_ErrMen := 'El Credito esta Vacio.';
		SET Var_Control:= 'creditoID' ;
		LEAVE ManejoErrores;
	END IF;

    SET Var_SoliciCredID := (SELECT SolicitudCreditoID FROM CREDITOS WHERE CreditoID =  Par_CreditoID);

    SET @idCarta := 0;

    DELETE FROM TMPCREDCARTAS WHERE NumTransaccion = Aud_NumTransaccion;
    INSERT INTO TMPCREDCARTAS (IDTmp, AsignacionCartaID, CasaComercialID, Monto, MontoDispersion, Estatus,	DispCasa,   NumTransaccion)
        SELECT (@idCarta := @idCarta +1 ), ASI.AsignacionCartaID, CAS.CasaComercialID, ASI.Monto, ASI.MontoDispersion,
                ASI.Estatus, CAS.TipoDispersionCasa,    Aud_NumTransaccion
        FROM ASIGCARTASLIQUIDACION ASI
            INNER JOIN CASASCOMERCIALES CAS ON  CAS.CasaComercialID = ASI.CasaComercialID
        WHERE SolicitudCreditoID = Var_SoliciCredID AND FechaVigencia >= Var_FechaSistema
                AND CAS.Estatus = Est_Activo AND CAS.TipoDispersionCasa = Var_SPEI;

    SET Var_NumCartas := (SELECT COUNT(*) FROM TMPCREDCARTAS WHERE NumTransaccion = Aud_NumTransaccion);
    SET Var_NumCartas := IFNULL(Var_NumCartas, Entero_Cero);
    SET Var_Conta := 0;

    IF (Var_NumCartas > Entero_Cero) THEN
        WHILE Var_Conta < Var_NumCartas DO

            SELECT 	CasaComercialID, Monto
            INTO 	Var_CasaCom,    Var_MontoCarta
            FROM TMPCREDCARTAS
            WHERE IDTmp = Var_Conta
                AND NumTransaccion = Aud_NumTransaccion;

            SELECT NombreCasaCom,       InstitucionID,      CuentaCLABE
            INTO    Var_NombreBenefi,   Var_InstitRecep,    VarCuentaCLABE
            FROM CASASCOMERCIALES
                 WHERE CasaComercialID = Var_CasaCom;

            SET Var_NombreBenefi := IFNULL(Var_NombreBenefi, Cadena_Vacia);
            SET Var_InstitRecep := IFNULL(Var_InstitRecep, Entero_Cero);


            SELECT Cre.CuentaID,    Cre.MonedaID
            INTO Var_CuentaAhoID,   Var_MonedaID
            FROM CREDITOS Cre
                WHERE CreditoID = Par_CreditoID;


            SELECT 	Par.Clabe,			Inst.NombreCorto,				Inst.RFC
            INTO Var_ClabeOrdenante,	Var_NombreOrdenante,			Var_RFCOrdenante
            FROM PARAMETROSSPEI Par
                LEFT JOIN INSTITUCIONES Inst ON Par.ParticipanteSpei = Inst.ClaveParticipaSpei
            LIMIT 1;

            SET Var_ClabeOrdenante	:=  IFNULL(Var_ClabeOrdenante, Cadena_Vacia);
            SET Var_NombreOrdenante := IFNULL(Var_NombreOrdenante, Cadena_Vacia);
            SET Var_RFCOrdenante := IFNULL(Var_RFCOrdenante, Cadena_Vacia);

            SET Var_ComisionTrans := Decimal_Cero;
            SET Var_ComisionIVA := Decimal_Cero;

            SET Var_TotalCargoCuenta := Par_Monto + Var_ComisionTrans + Var_ComisionIVA;
            SET Var_TotalCargoCuenta := Var_TotalCargoCuenta - Var_MontoCarta;

            SELECT SUBSTRING(NombreCompleto, 1, 30)
                INTO Var_UsuEnvioSPEI
                FROM USUARIOS
                WHERE UsuarioID =  Aud_Usuario;

            SET Var_UsuEnvioSPEI := IFNULL(Var_UsuEnvioSPEI, Cadena_Vacia);

            SELECT SUBSTRING(DATE_FORMAT(FechaSistema, '%y%m%d'), 1, 7)
            INTO Var_FechaSinGuion
            FROM PARAMETROSSIS
                LIMIT 1;

            SET Var_FechaSinGuion := IFNULL(Var_FechaSinGuion, Cadena_Vacia);
            SET Var_ReferenciaNum := CAST(Var_FechaSinGuion AS UNSIGNED);

            SET Var_MontoFinal := Par_Monto - Var_MontoCarta;

            -- SE REGISTRA EL SPEI ENVIO
            CALL SPEIENVIOSPRO (	Var_FolioEnvio, 		Var_ClaveRastreo, 		Var_TipoPagoTercer,		Var_CuentaAhoID,		Var_TipoCuentaOrd,
                                    Var_ClabeOrdenante, 	Var_NombreOrdenante,	Var_RFCOrdenante,		Var_MonedaID,			Entero_Cero,
                                    Var_MontoFinal,		    Decimal_Cero,			Var_ComisionTrans,		Var_ComisionIVA,		Var_TotalCargoCuenta,
                                    Var_InstitRecep,		VarCuentaCLABE,			Var_NombreBenefi,		Var_RFCBenefi,			Var_TipoCuentaBen,
                                    Var_ConceptoPago,		Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,			Entero_Cero,
                                    Cadena_Vacia,			Cadena_Vacia,			Var_ReferenciaNum,		Var_UsuEnvioSPEI,		Var_AreaBanco,
                                    Var_OrigenOperVent,		SalidaNO,				Par_NumErr,				Par_ErrMen,				Par_EmpresaID,
                                    Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
                                    Aud_NumTransaccion);


            IF (Par_NumErr != Entero_Cero) THEN
                LEAVE ManejoErrores;
            END IF;

            CALL SPEIENVIOSDESEMBOLSOALT(
                Var_FolioEnvio,		Par_CreditoID,		Var_BloqueoID,			SalidaNO,				Par_NumErr,
                Par_ErrMen,			Par_EmpresaID,		Aud_UUsuario,			Aud_FechaActual,		Aud_DireccionIP,
                Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
            );

            IF (Par_NumErr != Entero_Cero) THEN
                LEAVE ManejoErrores;
            END IF;

            CALL SPEIENVIOSACT(
                Var_FolioEnvio,		Cadena_Vacia,		Entero_Cero,			Entero_Cero,			Cadena_Vacia,
                Cadena_Vacia,		Entero_Cero,		Entero_Cero,			Act_EstatusDesemPen,	SalidaNO,
                Par_NumErr,			Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
                Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion
            );

            IF (Par_NumErr != Entero_Cero) THEN
                LEAVE ManejoErrores;
            END IF;
        END WHILE;
    END IF;

    DELETE FROM TMPCREDCARTAS WHERE NumTransaccion = Aud_NumTransaccion;

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Proceso de SPEI por Cartas de Liq. realizado Correctamente';
	SET Var_Control:= 'creditoID' ;

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS Control;
END IF;

END TerminaStore$$
