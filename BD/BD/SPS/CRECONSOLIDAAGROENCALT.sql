-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECONSOLIDAAGROENCALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRECONSOLIDAAGROENCALT`;

DELIMITER $$
CREATE PROCEDURE `CRECONSOLIDAAGROENCALT`(
	-- =======================================================================================
	-- ----------SP PARA DAR DE ALTA LA CABECERA DE LOS CREDITOS CONSOLIDADOS -----------
	-- =======================================================================================
	INOUT Var_FolioSalida		BIGINT(12),			-- ID o Referencia de Consolidacion

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
	DECLARE Var_FechaSis			DATE;               -- Variable Fecha del Sistema
	DECLARE Var_EsAgropecuario      CHAR(1);            -- Variable Es Agropecuario
	DECLARE Var_GarantiaFIRA        INT(11);            -- Tipo de Garantia FIRA ligado al Credito CATTIPOGARANTIAFIRA
	DECLARE Var_CreditoPivote       BIGINT(12);         -- Credito Pivote con el cual se realizara las validaciones
	DECLARE Var_FolioCons           BIGINT(12);            -- Folio de Consolidacion

	-- Declaracion de constantes
	DECLARE Entero_Cero				INT(11);
	DECLARE Decimal_Cero            DECIMAL(12,2);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Fecha_Vacia     		DATE;
	DECLARE SalidaSi  				CHAR(1);
	DECLARE SalidaNo  				CHAR(1);
	DECLARE Est_Vigente             CHAR(1);
	DECLARE Cons_SI                 CHAR(1);
	DECLARE Cons_NO                 CHAR(1);
	DECLARE NoAplicado              CHAR(1);

	-- Asignacion de constantes
	SET Entero_Cero     			:= 0;               -- Entero Cero
	SET Decimal_Cero     			:= 0.0;             -- Decimal Cero
	SET Cadena_Vacia    			:= '';              -- String Vacio
	SET Fecha_Vacia     			:= '1900-01-01';    -- Fecha Vacia
	SET SalidaSi					:= 'S';             -- Salida SI
	SET SalidaNo					:= 'N';             -- Salida NO
	SET Est_Vigente                 := 'V';             -- Estatus Vigente
	SET Cons_SI                     := 'S';             -- Constante SI
	SET Cons_NO                     := 'N';             -- Constante NO
	SET NoAplicado                  := 'N';             -- Estatus No Aplicado

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								  'Disculpe las molestias que esto le ocasiona. Ref: SP-CRECONSOLIDAAGROENCALT');
				SET Var_Control := 'sqlexception';
			END;

		SET Var_FechaSis := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
		SET Var_FechaSis := IFNULL(Var_FechaSis,Fecha_Vacia);
		SET Aud_FechaActual := NOW();

		SELECT IFNULL(MAX(FolioConsolida), Entero_Cero) + 1
		INTO Var_FolioCons
		FROM CRECONSOLIDAAGROENC FOR UPDATE;

		INSERT INTO CRECONSOLIDAAGROENC
			(FolioConsolida,		FechaConsolida,		SolicitudCreditoID,		CreditoID,			FechaDesembolso,
			CantRegistros,			MontoConsolidado,	Estatus,				EmpresaID,			Usuario,
			FechaActual,			DireccionIP,		ProgramaID,				Sucursal,			NumTransaccion)
		VALUES(
			Var_FolioCons,			Var_FechaSis,		Entero_Cero,			Entero_Cero,		Fecha_Vacia,
			Entero_Cero,			Decimal_Cero,		NoAplicado,				Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

		SET Par_NumErr 		:= Entero_Cero;
		SET Par_ErrMen 		:= 'Alta de Cabecera de Creditos Consolidados Agregado Exitosamente';
		SET Var_Control		:= 'solicitudCreditoID';
		SET Var_FolioSalida	:= Var_FolioCons;

	END ManejoErrores;

		IF (Par_Salida = SalidaSi) THEN
			SELECT 	Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Var_FolioSalida AS consecutivo;
		END IF;

END TerminaStore$$