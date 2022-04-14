-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECONSOLIDAAGROBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRECONSOLIDAAGROBAJ`;
DELIMITER $$

CREATE PROCEDURE `CRECONSOLIDAAGROBAJ`(
# =========================================================================
# ----------SP PARA DAR DE BAJA LOS CREDITOS CONSOLIDADOS-----------
# =========================================================================
    Par_FolioConsolida          BIGINT(12),        	-- Folio de Consolidacion
	Par_DetalleID				BIGINT(12),			-- ID del Detalle de Consolidacion
    Par_CreditoID 				BIGINT(12),     	-- Credito ID a Consiliar
	Par_Transaccion				BIGINT(20),     	-- Numero de Transaccion de la tabla en sesion
	Par_TipoBaja				INT(11),			-- Tipo de Baja

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
    DECLARE Var_Estatus				CHAR(1);            -- Variable Estatus del Credito
    DECLARE Var_EsAgropecuario      CHAR(1);            -- Variable Es Agropecuario
    DECLARE Var_CreditoPivote       BIGINT(12);         -- Credito Pivote con el cual se realizara las validaciones
	DECLARE Var_FolioCons			BIGINT(12);			-- Folio de Consolidacion
	DECLARE Var_CreditoGrid			BIGINT(12);			-- Credito de Detalle Grid
    -- Declaracion de constantes
	DECLARE Entero_Cero				INT(11);
	DECLARE SalidaSi  				CHAR(1);
	DECLARE SalidaNo  				CHAR(1);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Var_FechaSis			DATE;
	DECLARE Fecha_Vacia     		DATE;
    DECLARE Est_Vigente             CHAR(1);
	DECLARE Est_Vencido             CHAR(1);
    DECLARE Cons_SI                 CHAR(1);
    DECLARE Cons_NO                 CHAR(1);
	DECLARE BajaRegGRID				INT(11);
	DECLARE BajaFolioGRID			INT(11);
	DECLARE BajaDetalle				INT(11);

    -- Asignacion de constantes
	SET Cadena_Vacia    			:= '';              -- String Vacio
	SET Fecha_Vacia     			:= '1900-01-01';    -- Fecha Vacia
	SET Entero_Cero     			:= 0;               -- Entero en Cero
	SET SalidaSi					:= 'S';             -- Salida SI
	SET SalidaNo					:= 'N';             -- Salida NO
    SET Est_Vigente                 := 'V';             -- Estatus Vigente
	SET Est_Vencido                 := 'B';             -- Estatus Vigente
    SET Cons_SI                     := 'S';             -- Constante SI
    SET Cons_NO                     := 'N';             -- Constante NO
	SET BajaRegGRID					:= 1;				-- Baja especifica de Registro en la Tabla Espejo
	SET BajaFolioGRID				:= 2;				-- Baja de todos los Registros del Folio en la Tabla Espejo
	SET BajaDetalle					:= 3;				-- Baja

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								  'Disculpe las molestias que esto le ocasiona. Ref: SP-CRECONSOLIDAAGROBAJ');
				SET Var_Control := 'sqlexception';
			END;


		SELECT FolioConsolida
		INTO Var_FolioCons
		FROM CRECONSOLIDAAGROENC
			  WHERE FolioConsolida = Par_FolioConsolida;

		SET Var_FolioCons := IFNULL(Var_FolioCons, Entero_Cero);

		IF(Var_FolioCons = Entero_Cero)THEN
			SET Par_NumErr  := 1;
            SET Par_ErrMen  := 'El Folio de Consolidacion No Existe.';
            SET Var_Control  := 'folioConsolida';
		  	LEAVE ManejoErrores;
		END IF;

		-- Realiza la Eliminacion de un Registro del Grid de Creditos Consolidados
		IF(Par_TipoBaja = BajaRegGRID)THEN

			SELECT CreditoID
			INTO Var_CreditoGrid
			FROM CREDCONSOLIDAAGROGRID
				WHERE FolioConsolida = Par_FolioConsolida
					AND DetGridID = Par_DetalleID
					AND CreditoID = Par_CreditoID
					AND Transaccion = Par_Transaccion;

			SET Var_CreditoGrid := IFNULL(Var_CreditoGrid, Entero_Cero);

			IF(Var_CreditoGrid = Entero_Cero)THEN
				SET Par_NumErr  := 2;
				SET Par_ErrMen  := 'El Credito No Existe.';
				SET Var_Control  := 'creditoID';
				LEAVE ManejoErrores;
			END IF;

			SET Par_Transaccion := IFNULL(Par_Transaccion,Entero_Cero);

			IF(Par_Transaccion = Entero_Cero)THEN
				SET Par_NumErr  := 3;
				SET Par_ErrMen  := 'El Numero de Transaccion esta Vacio.';
				SET Var_Control  := 'numTransaccion';
				LEAVE ManejoErrores;
			END IF;

			DELETE FROM CREDCONSOLIDAAGROGRID
			WHERE FolioConsolida = Par_FolioConsolida
				AND CreditoID = Par_CreditoID
				AND DetGridID = Par_DetalleID
				AND Transaccion = Par_Transaccion;
		END IF;

		-- Realiza la Eliminacion de los Registros del Folio Consolida en CREDCONSOLIDAAGROGRID
		IF(Par_TipoBaja = BajaFolioGRID)THEN

			SET Par_Transaccion := IFNULL(Par_Transaccion,Entero_Cero);

			IF(Par_Transaccion = Entero_Cero)THEN
				SET Par_NumErr  := 4;
				SET Par_ErrMen  := 'El Numero de Transaccion esta Vacio.';
				SET Var_Control  := 'numTransaccion';
				LEAVE ManejoErrores;
			END IF;

			DELETE FROM CREDCONSOLIDAAGROGRID
			WHERE FolioConsolida = Par_FolioConsolida
				AND Transaccion = Par_Transaccion;
		END IF;

		-- Realiza la Eliminacion de los Registros del Folio Consolida CRECONSOLIDAAGRODET
		IF(Par_TipoBaja = BajaDetalle)THEN
			DELETE FROM CRECONSOLIDAAGRODET
			WHERE FolioConsolida = Par_FolioConsolida;
		END IF;



		SET Par_NumErr 			:= 0;
		SET Par_ErrMen 			:= 'Credito Consolidado Eliminado Exitosamente';
        SET Var_Control			:= 'solicitudCreditoID';

	END ManejoErrores;

		IF (Par_Salida = SalidaSi) THEN
			SELECT 	Par_NumErr AS NumErr,
			   		Par_ErrMen AS ErrMen,
			   		Var_Control AS control;
		END IF;

END TerminaStore$$