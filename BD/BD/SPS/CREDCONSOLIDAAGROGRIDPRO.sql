-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDCONSOLIDAAGROGRIDPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDCONSOLIDAAGROGRIDPRO`;

DELIMITER $$
CREATE PROCEDURE `CREDCONSOLIDAAGROGRIDPRO`(
	-- =========================================================================
	-- --------- SP PARA DAR DE ALTA LOS CREDITOS CONSOLIDADOS AL GRID ---------
	-- =========================================================================
	Par_FolioConsolida          BIGINT(12),        	-- Folio de Consolidacion
	Par_CreditoID 				BIGINT(12),     	-- Credito ID a Consiliar
	Par_SolicitudCreditoID      BIGINT(20),         -- ID de la Solicitud
	Par_Transaccion				BIGINT(20),     	-- Numero de Transaccion de la tabla en sesion
	Par_FechaProyeccion			DATE,				-- Fecha de Proyeccion

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
	DECLARE Var_FolioCons           BIGINT(12);            -- Variable Folio de Consolidacion

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

	SET Par_SolicitudCreditoID	:= IFNULL(Par_SolicitudCreditoID, Entero_Cero);
	SET Par_FechaProyeccion		:= IFNULL(Par_FechaProyeccion, Fecha_Vacia);

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								  'Disculpe las molestias que esto le ocasiona. Ref: SP-CREDCONSOLIDAAGROGRIDPRO');
				SET Var_Control := 'sqlexception';
			END;

		SET Par_FolioConsolida 	:= IFNULL(Par_FolioConsolida,Entero_Cero);

		SET Var_FechaSis := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
		SET Var_FechaSis := IFNULL(Var_FechaSis,Fecha_Vacia);


		IF(NOT EXISTS(SELECT CreditoID
			  FROM CREDITOS
			  WHERE CreditoID = Par_CreditoID)) THEN
			SET Par_NumErr  := 1;
			SET Par_ErrMen  := 'El Credito No Existe.';
			SET Var_Control  := 'creditoID';
		  LEAVE ManejoErrores;
		END IF;

		SELECT	Estatus,		EsAgropecuario
		INTO	Var_Estatus,	Var_EsAgropecuario
		FROM CREDITOS
		WHERE CreditoID = Par_CreditoID;

		SET Var_Estatus := IFNULL(Var_Estatus, Cadena_Vacia);

		IF(Var_Estatus NOT IN(Est_Vigente, Est_Vencido)) THEN
			SET Par_NumErr 	:= 2;
			SET Par_ErrMen 	:= 'El Estatus del Credito no es Valido.';
			SET Var_Control	:= 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_EsAgropecuario = Cons_NO) THEN
			SET Par_NumErr 	:= 3;
			SET Par_ErrMen 	:= 'El Credito ligado no es Agropecuario.';
			SET Var_Control	:= 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_FolioConsolida = Entero_Cero) THEN
			-- Se inserta la Cabecera de Consolidaciones
			CALL CRECONSOLIDAAGROENCALT (
				Var_FolioCons,      SalidaNo,           Par_NumErr,         Par_ErrMen,         Par_EmpresaID,
				Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
				Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			SET Par_FolioConsolida  := Var_FolioCons;
			SET Par_Transaccion		:= Aud_NumTransaccion;
		END IF;

		CALL CRECONSOLIDAAGROGRIDALT (
			Par_FolioConsolida,		Par_CreditoID,		Par_SolicitudCreditoID,		Par_Transaccion,	Par_FechaProyeccion,
			SalidaNo,				Par_NumErr,			Par_ErrMen,					Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,				Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr 	:= Entero_Cero;
		SET Par_ErrMen 	:= 'Credito Consolidado Agregado Exitosamente';
		SET Var_Control	:= 'solicitudCreditoID';

	END ManejoErrores;

	IF (Par_Salida = SalidaSi) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Par_FolioConsolida AS consecutivo,
				Par_Transaccion AS consecutivoString;
	END IF;

END TerminaStore$$