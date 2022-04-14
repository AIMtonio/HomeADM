-- SP AFILIACUENTASCLABESPRO

DELIMITER ;

DROP PROCEDURE IF EXISTS AFILIACUENTASCLABESPRO;

DELIMITER $$

CREATE PROCEDURE `AFILIACUENTASCLABESPRO`(
# =========================================================================
# --------- STORE PARA EL PROCESO DE AFILIACIONES CUENTAS CLABES ----------
# =========================================================================
	Par_CuentaClabe			VARCHAR(18),		-- Cuenta Clabe
    Par_ClaveAfiliacion		CHAR(2),			-- Clave de Afiliacion
    Par_Tipo				CHAR(1),			-- Tipo: A = Alta B =  Baja
    Par_NumAfiliacionID		INT(11),			-- Numero de Afiliacion

    Par_Salida           	CHAR(1),			-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr     	INT(11),			-- Numero de Error
	INOUT Par_ErrMen     	VARCHAR(400),		-- Mensaje de Error

	Par_EmpresaID       	INT(11),			-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),			-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,			-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),		-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),			-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
	)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE	Var_Control     	VARCHAR(100);	-- Almacena el control de errores
    DECLARE	Var_FolioAfiliacion	INT(11);		-- Folio de Afiliacion
    DECLARE Var_CuentaClabe		VARCHAR(18);	-- Numero de Cuenta Clabe
    DECLARE Var_ClienteID       INT(11);		-- Numero del Cliente
	DECLARE Var_InstitucionID   INT(11);		-- Numero de la Institucion

	-- Declaracion de Constantes
	DECLARE Entero_Cero    		INT(11);
	DECLARE Cadena_Vacia   		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	SalidaSI        	CHAR(1);
    DECLARE	SalidaNO        	CHAR(1);

	DECLARE ClaveExitosa		CHAR(2);
    DECLARE ClaveErronea		CHAR(2);
    DECLARE ConstanteSI			CHAR(1);
    DECLARE EstatusAfiliada		CHAR(1);
    DECLARE TipoAfiliacion		CHAR(1);

    DECLARE TipoAmbas			CHAR(1);
	DECLARE CodigoNoAdmite		CHAR(2);
	DECLARE CodigoIndomiciliado CHAR(2);
    DECLARE CodigoBajaOficina	CHAR(2);
    DECLARE CodigoCuentasBaja	CHAR(2);

    DECLARE CodigoDomiciliaBaja	CHAR(2);
    DECLARE EstatusNoAfiliada	CHAR(1);
    DECLARE TipoAlta			CHAR(1);
    DECLARE TipoBaja			CHAR(1);
    DECLARE EstatusBaja			CHAR(1);

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0; 				-- Entero Cero
	SET Cadena_Vacia		:= '';    			-- Cadena Vacia
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET	SalidaSI        	:= 'S';				-- Salida Si
    SET	SalidaNO        	:= 'N'; 			-- Salida No

	SET ClaveExitosa		:= '00';			-- Clave Exitosa para Afiliada
    SET ConstanteSI			:= 'S';				-- Constante: SI
    SET EstatusAfiliada		:= 'A';				-- Estatus: Afiliada
	SET TipoAfiliacion		:= 'F'; 			-- Tipo Codigo: Afiliacion

    SET TipoAmbas			:= 'A'; 			-- Tipo Codigo: Ambas
    SET CodigoNoAdmite		:= '19';			-- Tipo de Cuenta no Admite Domiciliaciones
    SET CodigoIndomiciliado	:= '20';			-- Indomiciliado
    SET CodigoBajaOficina	:= '23';			-- Baja por oficina
    SET CodigoCuentasBaja	:= '25';			-- Todas las domiciliaciones de la cuenta fueron dadas de baja

    SET CodigoDomiciliaBaja	:= '26';			-- Domiciliación dada de baja
    SET EstatusNoAfiliada	:= 'N';				-- Estatus: No Afiliada
    SET TipoAlta			:= 'A';				-- Tipo: Alta
    SET TipoBaja			:= 'B';				-- Tipo: Baja
    SET EstatusBaja			:= 'B';				-- Estatus: Baja

    ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-AFILIACUENTASCLABESPRO');
			SET Var_Control:= 'SQLEXCEPTION' ;
		END;

        SET Aud_FechaActual := NOW();

        -- Actulizacion para Tipo: ALTA
        IF(Par_Tipo = TipoAlta)THEN
			-- Se actualiza el campo EstatusDomicilio de la tabla CUENTASTRANSFER una vez procesada las Afiliaciones           
			UPDATE CUENTASTRANSFER Cta,
				   TMPAFILIACUENTASCLABE Tmp,
                   CATCODIGOSAFILIADOM Cat
			SET Cta.EstatusDomici	= IF(Tmp.ClaveAfiliacion = ClaveExitosa,EstatusAfiliada,EstatusNoAfiliada),
				Cta.EmpresaID 		= Par_EmpresaID,
				Cta.Usuario 		= Aud_Usuario,
				Cta.FechaActual 	= Aud_FechaActual,
				Cta.DireccionIP 	= Aud_DireccionIP,
				Cta.ProgramaID 		= Aud_ProgramaID,
				Cta.Sucursal		= Aud_Sucursal,
				Cta.NumTransaccion 	= Aud_NumTransaccion
			WHERE Cta.Clabe 		= Tmp.CuentaClabe
			AND Cta.ClienteID 		= Tmp.ClienteID
            AND Tmp.ClaveAfiliacion = Cat.ClaveCodigo
			AND Tmp.CuentaClabe 	= Par_CuentaClabe
			AND Tmp.ClaveAfiliacion = Par_ClaveAfiliacion
			AND Tmp.Tipo 			= Par_Tipo
			AND Tmp.NumAfiliacionID = Par_NumAfiliacionID
			AND Cat.TipoCodigo IN(TipoAfiliacion,TipoAmbas);

			-- Se actualiza el campo EstatusDomicilia y Comentario en la tabla DETAFILIABAJACTADOM
			UPDATE DETAFILIABAJACTADOM Det,
				   TMPAFILIACUENTASCLABE Tmp,
                   CATCODIGOSAFILIADOM Cat
			SET EstatusDomicilia = IF(Tmp.ClaveAfiliacion = ClaveExitosa,EstatusAfiliada,EstatusNoAfiliada),
				Comentario		 = IF(Tmp.ClaveAfiliacion = ClaveExitosa,Cadena_Vacia,Cat.Descripcion),
				Det.EmpresaID 		= Par_EmpresaID,
				Det.Usuario 		= Aud_Usuario,
				Det.FechaActual 	= Aud_FechaActual,
				Det.DireccionIP 	= Aud_DireccionIP,
				Det.ProgramaID 		= Aud_ProgramaID,
				Det.Sucursal		= Aud_Sucursal,
				Det.NumTransaccion 	= Aud_NumTransaccion
			WHERE Det.Clabe 		= Tmp.CuentaClabe
			AND Det.ClienteID 		= Tmp.ClienteID
			AND Tmp.ClaveAfiliacion = Cat.ClaveCodigo
			AND Tmp.CuentaClabe 	= Par_CuentaClabe
            AND Tmp.Tipo 			= Par_Tipo
            AND Cat.TipoCodigo IN(TipoAfiliacion,TipoAmbas);

		END IF;

		 -- Actulizacion para Tipo: BAJA
        IF(Par_Tipo = TipoBaja)THEN
			-- Se actualiza el el campo EstatusDomicilio de la tabla CUENTASTRANSFER una vez procesada las Afiliaciones
			UPDATE CUENTASTRANSFER Cta,
				   TMPAFILIACUENTASCLABE Tmp,
                    CATCODIGOSAFILIADOM Cat
			SET Cta.EstatusDomici   = IF(Tmp.ClaveAfiliacion IN(CodigoNoAdmite,CodigoIndomiciliado,
																CodigoBajaOficina,CodigoCuentasBaja,
                                                                CodigoDomiciliaBaja),EstatusBaja,EstatusAfiliada),
				Cta.EmpresaID 		= Par_EmpresaID,
				Cta.Usuario 		= Aud_Usuario,
				Cta.FechaActual 	= Aud_FechaActual,
				Cta.DireccionIP 	= Aud_DireccionIP,
				Cta.ProgramaID 		= Aud_ProgramaID,
				Cta.Sucursal		= Aud_Sucursal,
				Cta.NumTransaccion 	= Aud_NumTransaccion
			WHERE Cta.Clabe 		= Tmp.CuentaClabe
			AND Cta.ClienteID 		= Tmp.ClienteID
			AND Tmp.ClaveAfiliacion = Cat.ClaveCodigo
			AND Tmp.CuentaClabe 	= Par_CuentaClabe
			AND Tmp.ClaveAfiliacion = Par_ClaveAfiliacion
			AND Tmp.Tipo 			= Par_Tipo
			AND Tmp.NumAfiliacionID = Par_NumAfiliacionID
            AND Cat.TipoCodigo IN(TipoAfiliacion,TipoAmbas);

			-- Se actualiza el campo EstatusDomicilia y Comentario en la tabla DETAFILIABAJACTADOM
			UPDATE DETAFILIABAJACTADOM Det,
				   TMPAFILIACUENTASCLABE Tmp,
                   CATCODIGOSAFILIADOM Cat
			SET EstatusDomicilia = IF(Tmp.ClaveAfiliacion IN(CodigoNoAdmite,CodigoIndomiciliado,CodigoBajaOficina,CodigoCuentasBaja,CodigoDomiciliaBaja),EstatusBaja,EstatusAfiliada),
				Comentario		 = Cat.Descripcion,
				Det.EmpresaID 		= Par_EmpresaID,
				Det.Usuario 		= Aud_Usuario,
				Det.FechaActual 	= Aud_FechaActual,
				Det.DireccionIP 	= Aud_DireccionIP,
				Det.ProgramaID 		= Aud_ProgramaID,
				Det.Sucursal		= Aud_Sucursal,
				Det.NumTransaccion 	= Aud_NumTransaccion
			WHERE Det.Clabe 		= Tmp.CuentaClabe
			AND Det.ClienteID 		= Tmp.ClienteID
            AND Tmp.ClaveAfiliacion = Cat.ClaveCodigo
			AND Tmp.CuentaClabe 	= Par_CuentaClabe
            AND Tmp.Tipo = Par_Tipo
            AND Cat.TipoCodigo IN(TipoAfiliacion,TipoAmbas);

		END IF;

		-- Se eliminan los registros una vez procesada las Afiliaciones o Bajas de Cuentas Clabes
		DELETE FROM TMPAFILIACUENTASCLABE
			WHERE CuentaClabe 	= Par_CuentaClabe
			AND ClaveAfiliacion = Par_ClaveAfiliacion
			AND Tipo = Par_Tipo
			AND NumAfiliacionID = Par_NumAfiliacionID;

		SET Par_NumErr      := Entero_Cero;
		SET Par_ErrMen      := 'Afiliacion Cuentas Clabes Procesada Exitosamente.';
		SET Var_Control		:= 'adjuntar';

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control	AS Control,
				Par_CuentaClabe AS Consecutivo;
	END IF;

END TerminaStore$$