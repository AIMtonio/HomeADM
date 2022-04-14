-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECONSOLIDAAGROVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRECONSOLIDAAGROVAL`;
DELIMITER $$

CREATE PROCEDURE `CRECONSOLIDAAGROVAL`(
-- =======================================================================================
-- ----------SP PARA DE CONSOLIDACION DE LOS CREDITOS CONSOLIDADOS -----------
-- =======================================================================================
    Par_FolioConsolida          BIGINT(12),         -- ID o Referencia de Consolidacion
    Par_CreditoID 				BIGINT(12),         -- Credito ID a Consiliar
	Par_Transaccion				BIGINT(20),         -- Numero de Transaccion de Sesison

	Par_Salida					CHAR(1),			-- Indica si se muestra mensaje de exito o no
	INOUT Par_NumErr			INT(11),			-- Numero de error
	INOUT Par_ErrMen			VARCHAR(400),		-- Mensaje de error

	Par_EmpresaID				INT(11),			-- Parametro de auditoria
	Aud_Usuario					INT(11),			-- Parametro de auditoria
	Aud_FechaActual				DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal				INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de auditoria
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Control		        VARCHAR(100);
	DECLARE Var_CreditoID 			BIGINT(12);			-- Variable Credito ID
    DECLARE Var_Estatus				CHAR(1);            -- Variable Estatus del Credito
    DECLARE Var_FechaSis			DATE;               -- Variable Fecha del Sistema
    DECLARE Var_EsAgropecuario      CHAR(1);            -- Variable Es Agropecuario
    DECLARE Var_GarantiaCredito     INT(11);            -- Tipo de Garantia FIRA ligado al Credito CATTIPOGARANTIAFIRA
	DECLARE Var_EstGarantiaCredito	CHAR(1);			-- Variable de Estatus de Garantia
	DECLARE Var_GarantiaPivote     	INT(11);            -- Valor de Pivote. Tipo de Garantia FIRA ligado al Credito CATTIPOGARANTIAFIRA
	DECLARE Var_EstGarantiaPivote	CHAR(1);			-- Valor de Pivote. Variable de Estatus de Garantia
    DECLARE Var_CreditoPivote       BIGINT(12);         -- Credito Pivote con el cual se realizara las validaciones
    DECLARE Var_FolioCons           BIGINT(12);            -- Folio de Consolidacion
	DECLARE Var_CreditoFondeoID		BIGINT(20);			-- Identificador o ID de Fondeo (Pasivo)
	DECLARE Var_EstCredFondeo		CHAR(1);			-- Estatus del Credito de Fondeo (Pasivo)
	DECLARE Var_CreditoCont			BIGINT(12);			-- Identificador o ID de Credito Contigente
	DECLARE Var_EstCredCont			CHAR(1);			-- Estatus del Credito Contigente
	DECLARE Var_GarLiqCredito		DECIMAL(12,2);		-- Monto de garantia Liquida
	DECLARE Var_GarLiqPivote	    DECIMAL(12,2);		-- Monto de garantia Liquida para el Credito Pivote
	DECLARE Var_CuentaAhoID			BIGINT(12);			-- No de Cuenta Clabe del Credito
	DECLARE Var_BloqueoID			INT(11);			-- ID  de Bloqueo
	DECLARE Var_FolioBloq			INT(11);			-- Folio de Bloqueo
	DECLARE Var_DestinoIDCredito	INT(11);			-- Destino de Credito
    DECLARE Var_DestinoIDPivote 	INT(11);			-- Destino de Credito Pivote
	DECLARE Var_DetConsolidaID		INT(11);			-- Nuevo ID del Detalle de Consolida
	DECLARE Var_MontoCred			DECIMAL(12,2);		-- Monto de Credito
	DECLARE Var_ClasDestinoCredito	INT(11);			-- Clasificacion del Destino del Credito
    DECLARE Var_ClasDestinoPivote	INT(11);			-- Clasificacion del Destino del Credito Pivote
	DECLARE Var_TipoClasificacion   VARCHAR(20);        -- Tipo de Clasificacion del Credito
	DECLARE Var_LineaCreditoBaseID 	BIGINT(20);			-- Linea de Credito asociada al crédito pivote
	DECLARE Var_LineaCreditoID 		BIGINT(20);			-- Linea de Credito

    -- Declaracion de constantes
	DECLARE Entero_Cero				INT(11);
    DECLARE Decimal_Cero            DECIMAL(12,2);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Fecha_Vacia     		DATE;
    DECLARE SalidaSi  				CHAR(1);
	DECLARE SalidaNo  				CHAR(1);
    DECLARE Est_Vigente             CHAR(1);
	DECLARE Est_Vencido				CHAR(1);
    DECLARE Cons_SI                 CHAR(1);
    DECLARE Cons_NO                 CHAR(1);
    DECLARE NoAplicado              CHAR(1);
	DECLARE Gar_Inactiva			CHAR(1);
	DECLARE Gar_Aplicado			CHAR(1);
	DECLARE Est_Pagado				CHAR(1);
	DECLARE Tip_SinGarantia			INT(11);
	DECLARE Tip_GarantiaFEGA		INT(11);
	DECLARE Tip_GarantiaFONAGA		INT(11);
	DECLARE Tip_AmbasGarantia		INT(11);
	DECLARE Bloq_GarLiq				INT(11);
	DECLARE Mov_Bloqueo				CHAR(1);
    DECLARE Tip_Refaccionario       INT(11);
    DECLARE Tip_Avio                INT(11);

    -- Asignacion de constantes
    SET Entero_Cero     			:= 0;               -- Entero Cero
    SET Decimal_Cero     			:= 0.0;             -- Decimal Cero
	SET Cadena_Vacia    			:= '';              -- String Vacio
	SET Fecha_Vacia     			:= '1900-01-01';    -- Fecha Vacia
	SET SalidaSi					:= 'S';             -- Salida SI
	SET SalidaNo					:= 'N';             -- Salida NO
    SET Est_Vigente                 := 'V';             -- Estatus Vigente
    SET Est_Vencido                 := 'B';             -- Estatus Vencido
    SET Cons_SI                     := 'S';             -- Constante SI
    SET Cons_NO                     := 'N';             -- Constante NO
    SET NoAplicado                  := 'S';             -- Estatus No Aplicado
	SET Gar_Inactiva				:= 'I';				-- Estatus Inactivo para Garantia FIRA
	SET Gar_Aplicado				:= 'P';				-- Estatus Aplicado para Garantia FIRA
	SET Est_Pagado					:= 'P';				-- Estatus Pagado
	SET Tip_SinGarantia				:= 0;				-- Sin Garantia
	SET Tip_GarantiaFEGA			:= 1;				-- Garantia FIRA Fega
	SET Tip_GarantiaFONAGA			:= 2;				-- Garantia FIRA Fonaga
	SET Tip_AmbasGarantia			:= 3;				-- Garantia FIRA Ambas Fega/Fonaga
	SET Bloq_GarLiq					:= 8;				-- Tipo de Bloqueo por Garantia Liquida
	SET Mov_Bloqueo					:='B';				-- Naturaleza de Movimiento Bloqueo
    SET Tip_Refaccionario           := 126;             -- Tipo de Clasificacion Refaccionario
    SET Tip_Avio                    := 125;             -- Tipo de Clasificacion Avio
	SET Var_Control 				:= 'creditoID';		-- Seteo de Var Control
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								  'Disculpe las molestias que esto le ocasiona. Ref: SP-CRECONSOLIDAAGROVAL');
				SET Var_Control := 'sqlexception';
			END;

        SET Var_FechaSis := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
        SET Var_FechaSis := IFNULL(Var_FechaSis,Fecha_Vacia);

		SELECT CreditoID,	LineaCreditoID
		INTO Var_CreditoID,	Var_LineaCreditoID
		FROM CREDITOS
			  WHERE CreditoID = Par_CreditoID;

		SET Var_CreditoID 		:= IFNULL(Var_CreditoID, Entero_Cero);
		SET Var_LineaCreditoID	:= IFNULL(Var_LineaCreditoID, Entero_Cero);

		IF(Var_CreditoID = Entero_Cero)THEN
			SET Par_NumErr  := 1;
            SET Par_ErrMen  := 'El Credito No Existe.';
		  	LEAVE ManejoErrores;
		END IF;

		SELECT  Estatus,        EsAgropecuario
			INTO
				Var_Estatus,    Var_EsAgropecuario
		FROM CREDITOS
			WHERE CreditoID = Par_CreditoID;

		SET Var_Estatus := IFNULL(Var_Estatus, Cadena_Vacia);

		IF(Var_Estatus NOT IN(Est_Vigente, Est_Vencido)) THEN
			SET Par_NumErr 	:= 2;
			SET Par_ErrMen 	:= 'El Estatus del Credito no es Valido.';
			LEAVE ManejoErrores;
		END IF;

        IF(Var_EsAgropecuario = Cons_NO) THEN
			SET Par_NumErr 	:= 3;
			SET Par_ErrMen 	:= 'El Credito ligado no es Agropecuario.';
			LEAVE ManejoErrores;
		END IF;

		IF(EXISTS(SELECT CreditoID
			  FROM CREDCONSOLIDAAGROGRID
			  WHERE CreditoID = Par_CreditoID AND FolioConsolida = Par_FolioConsolida AND Transaccion = Par_Transaccion)) THEN
            SET Par_NumErr  := 4;
            SET Par_ErrMen  := 'El Credito a Consolidar se encuentra Registrado.';
            SET Var_Control  := 'folioConsolida';
		  LEAVE ManejoErrores;
		END IF;

		-- Se obtiene el Tipo de Garantia del Credito a Consolidar
		SELECT TipoGarantiaFIRAID,	EstatusGarantiaFIRA,		AporteCliente,		CuentaID,			DestinoCreID,
				MontoCredito
		INTO	Var_GarantiaCredito,	Var_EstGarantiaCredito,		Var_GarLiqCredito,		Var_CuentaAhoID,	Var_DestinoIDCredito,
				Var_MontoCred
		FROM CREDITOS
			WHERE CreditoID = Par_CreditoID;


		SET Var_GarantiaCredito := IFNULL(Var_GarantiaCredito, Entero_Cero);
		SET Var_EstGarantiaCredito := IFNULL(Var_EstGarantiaCredito, Gar_Inactiva);
		SET Var_GarLiqCredito := IFNULL(Var_GarLiqCredito, Decimal_Cero);

        SELECT SubClasifID
        INTO Var_ClasDestinoCredito
            FROM DESTINOSCREDITO
            WHERE DestinoCreID = Var_DestinoIDCredito;

		-- Si al credito se le ha aplicado una garantia, se debera verificar que esten Pagados los Creditos (Pasivo y Contingente)
		IF(Var_GarantiaCredito != Entero_Cero AND Var_EstGarantiaCredito = Gar_Aplicado)THEN
			SELECT CreditoFondeoID
			INTO Var_CreditoFondeoID
			FROM RELCREDPASIVOAGRO
				WHERE CreditoID = Par_CreditoID
					AND EstatusRelacion = Est_Vigente LIMIT 1;
			/* validar ya que puede tener dos pasivos al mismo credito */

			SET Var_CreditoFondeoID := IFNULL(Var_CreditoFondeoID, Entero_Cero);

			IF(Var_CreditoFondeoID > Entero_Cero) THEN
				SELECT Estatus
				INTO Var_EstCredFondeo
				FROM CREDITOFONDEO
					WHERE CreditoFondeoID = Var_CreditoFondeoID;
				/* Valdiar si se toma el Estatus con la tabla de RelCredPasivo*/
				SET Var_EstCredFondeo := IFNULL(Var_EstCredFondeo, Cadena_Vacia);

				IF(Var_EstCredFondeo != Est_Pagado)THEN
					SET Par_NumErr 	:= 3;
					SET Par_ErrMen 	:= 'El Credito Pasivo se encuentra Vigente. Favor de Liquidar.';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			SELECT 	CreditoID,			Estatus
			INTO 	Var_CreditoCont,	Var_EstCredCont
			FROM CREDITOSCONT
				WHERE CreditoID = Par_CreditoID;

			SET Var_CreditoCont := IFNULL(Var_CreditoCont, Entero_Cero);
			SET Var_EstCredCont := IFNULL(Var_EstCredCont, Cadena_Vacia);

			IF(Var_EstCredCont != Est_Pagado)THEN
				SET Par_NumErr 	:= 4;
				SET Par_ErrMen 	:= 'El Credito Contigente se encuentra Vigente. Favor de Liquidar.';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Se tomaran los valores del Primer Credito como Referancia para los demas Creditos
		SELECT CreditoID
		INTO Var_CreditoPivote
		FROM CREDCONSOLIDAAGROGRID
			WHERE FolioConsolida = Par_FolioConsolida
              AND Transaccion = Par_Transaccion
		ORDER BY DetGridID ASC LIMIT 1;

		SET Var_CreditoPivote := IFNULL(Var_CreditoPivote, Entero_Cero);

		IF(Var_CreditoPivote != Entero_Cero)THEN

			SELECT TipoGarantiaFIRAID,		EstatusGarantiaFIRA,			AporteCliente,          DestinoCreID,			LineaCreditoID
			INTO	Var_GarantiaPivote,		Var_EstGarantiaPivote,			Var_GarLiqPivote,       Var_DestinoIDPivote,	Var_LineaCreditoBaseID
			FROM CREDITOS
			WHERE CreditoID = Var_CreditoPivote;

			SET Var_GarantiaPivote := IFNULL(Var_GarantiaPivote, Entero_Cero);
			SET Var_EstGarantiaPivote := IFNULL(Var_EstGarantiaPivote, Gar_Inactiva);
			SET Var_GarLiqPivote := IFNULL(Var_GarLiqPivote, Decimal_Cero);
			SET Var_LineaCreditoBaseID	:= IFNULL(Var_LineaCreditoBaseID, Entero_Cero);

            SELECT SubClasifID
            INTO Var_ClasDestinoPivote
            FROM DESTINOSCREDITO
                WHERE DestinoCreID = Var_DestinoIDPivote;

			--  Si el Credito Pivote tiene una Garantia FEGA, todos los creditos posteriores deben de tener la misma Garantia
			IF(Var_GarantiaPivote = Tip_GarantiaFEGA AND Var_GarantiaPivote != Var_GarantiaCredito)THEN
				SET Par_NumErr 	:= 5;
				SET Par_ErrMen 	:= 'El Credito seleccionado no cuenta con una Garantia FEGA.';
				LEAVE ManejoErrores;
			END IF;

			--  Si el Credito Pivote tiene una Garantia FONAGA, todos los creditos posteriores deben de tener la misma Garantia
			IF(Var_GarantiaPivote = Tip_GarantiaFONAGA) THEN
				IF(Var_GarantiaPivote != Var_GarantiaCredito)THEN
					SET Par_NumErr 	:= 6;
					SET Par_ErrMen 	:= 'El Credito seleccionado no cuenta con una Garantia FONAGA.';
					LEAVE ManejoErrores;
				END IF;

				-- Si el Primer Credito cuenta con Garantia Liquida los Creditos posteriores deberan cumplir el mismo Requerimiento
				IF(Var_GarLiqPivote > Entero_Cero AND Var_GarLiqCredito = Entero_Cero)THEN
                    SET Par_NumErr 	:= 7;
                    SET Par_ErrMen 	:= 'El Credito seleccionado no esta Ligada a una Garantia Liquida.';
                    LEAVE ManejoErrores;
				END IF;

			END IF;
            -- verificar este paso
			--  Si el Credito cuenta con Ambas Garantias y esta no ha sido Aplicada permitira agregar el Registro
			IF(Var_GarantiaPivote = Tip_AmbasGarantia AND Var_GarantiaCredito = Tip_AmbasGarantia AND Var_EstGarantiaCredito != Gar_Inactiva)THEN
				SET Par_NumErr 	:= 8;
				SET Par_ErrMen 	:= 'El Tipo de Garantia Fega/Fonaga del Credito ha sido Autorizada.';
				LEAVE ManejoErrores;
			END IF;

            IF(Var_ClasDestinoPivote != Var_ClasDestinoCredito)THEN
                SET Var_TipoClasificacion := (CASE
                                                WHEN Var_ClasDestinoPivote = Tip_Refaccionario THEN 'REFACCIONARIO'
                                                WHEN Var_ClasDestinoPivote = Tip_Avio THEN 'AVIO'
                                                ELSE 'AVIO' END);
                SET Par_NumErr 	:= 9;
				SET Par_ErrMen 	:= CONCAT('El Tipo de Clasificacion del Credito debe de ser ',Var_TipoClasificacion);
				LEAVE ManejoErrores;
            END IF;


			-- Si el credito pivote posee una linea de credito todos los creditos deben tener la misma linea de credito
			-- En caso contrario la todos los creditos a consolidar deben estar sin linea
			IF( Var_LineaCreditoBaseID > Entero_Cero ) THEN

				IF( Var_LineaCreditoID = Entero_Cero ) THEN
					SET Par_NumErr 	:= 11;
					SET Par_ErrMen 	:= CONCAT('El Credito Pivote(',Var_CreditoPivote,') tiene asignada la Linea de Credito: ',Var_LineaCreditoBaseID,' pero el credito ',Par_CreditoID,
											  ' no cuenta con una linea de credito.');
					SET Var_Control	:= 'creditoID';
					LEAVE ManejoErrores;
				END IF;

				IF( Var_LineaCreditoBaseID <> Var_LineaCreditoID ) THEN
					SET Par_NumErr 	:= 12;
					SET Par_ErrMen 	:= CONCAT('La linea de Credito ',Var_LineaCreditoID,' asociada al credito: ',Par_CreditoID,
											  ' es distinta a la linea de credito pivote(',Var_CreditoPivote,'), la cual es: ',Var_LineaCreditoBaseID);
					SET Var_Control	:= 'creditoID';
					LEAVE ManejoErrores;
				END IF;
			ELSE
				IF( Var_LineaCreditoID <> Entero_Cero) THEN
					SET Par_NumErr 	:= 13;
					SET Par_ErrMen 	:= CONCAT('El Credito Pivote(',Var_CreditoPivote,') No cuenta con una Linea de Credito, por tal motivo no pueden asignarse creditos que cuente con una linea de credito');
					SET Var_Control	:= 'creditoID';
					LEAVE ManejoErrores;
				END IF;
			END IF;

		END IF;

		-- Se verifica que si el credito cuenta con una Garantia Liquida Asociada esta no debe estar Bloqueada para poder agregar
		IF(Var_GarLiqCredito > Decimal_Cero) THEN
			SELECT MAX(BloqueoID)
			INTO	Var_BloqueoID
			FROM BLOQUEOS
				WHERE TiposBloqID = Bloq_GarLiq AND NatMovimiento = Mov_Bloqueo
                    AND Referencia = Par_CreditoID;

   			SET Var_BloqueoID := IFNULL(Var_BloqueoID, Entero_Cero);

            SELECT FolioBloq
            INTO Var_FolioBloq
                FROM BLOQUEOS
                WHERE BloqueoID = Var_BloqueoID;

			SET Var_FolioBloq := IFNULL(Var_FolioBloq,Entero_Cero);

			IF(Var_BloqueoID > Entero_Cero AND Var_FolioBloq = Entero_Cero)THEN
				SET Par_NumErr 	:= 10;
				SET Par_ErrMen 	:= 'El Credito cuenta con Garantia Liquida Bloqueada.';
				SET Var_Control	:= 'creditoID';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Par_NumErr 			:= 0;
		SET Par_ErrMen 			:= 'Credito Consolidado  validado Correctamente';
        SET Var_Control			:= 'solicitudCreditoID';

	END ManejoErrores;

		IF (Par_Salida = SalidaSi) THEN
			SELECT 	Par_NumErr AS NumErr,
			   		Par_ErrMen AS ErrMen,
			   		Var_Control AS control;
		END IF;

END TerminaStore$$
