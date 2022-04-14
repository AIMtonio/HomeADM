
-- LOTETARJETADEBSAFIALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `LOTETARJETADEBSAFIALT`;
DELIMITER $$

CREATE PROCEDURE `LOTETARJETADEBSAFIALT`(

	Par_LoteDebitoSAFIID	INT(11),
	Par_TipoTarjetaDebID	INT(11),
	Par_FechaRegistro		DATE,
    Par_SucursalSolicita	CHAR(4),
	Par_UsuarioID			INT(11),

	Par_NumTarjetas			INT(11),
    Par_Estatus				INT(11),
	Par_EsAdicional			VARCHAR(5),
    Par_NomArchiGen			VARCHAR(50),
	Par_FolioInicial		INT(11),

	Par_FolioFinal			INT(11),
	Par_BitCargaID			INT(11),
	Par_ServiceCode			CHAR(3),
	Par_EsPersonaliz		CHAR(1),
	Par_EsVirtual			CHAR(1),

	Par_Salida				CHAR(1),
	INOUT Par_NumErr    	INT(11),
    INOUT Par_ErrMen    	VARCHAR(400),

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)

	)
TerminaStore:BEGIN

DECLARE Var_Control				VARCHAR(50);
DECLARE Var_Consecutivo			INT(11);
DECLARE Var_EstatusProceso      CHAR(1);    -- Estatus del proceso A = Activo I = Inactivo


DECLARE	Cadena_Vacia	 		CHAR(1);
DECLARE	Entero_Cero		 		INT(11);
DECLARE Entero_Uno		 		INT(11);
DECLARE	DecimalCero		 		DECIMAL(12,2);
DECLARE Salida_NO 		 		CHAR(1);
DECLARE	SalidaSI	 	 		CHAR(1);
DECLARE Var_LoteDebitoSAFIID 	INT(11);
DECLARE Var_Activo              CHAR(1);    -- Activo
DECLARE Cadena_NO				CHAR(1);
DECLARE Cadena_SI				CHAR(1);


SET	Cadena_Vacia	:= '';
SET	Entero_Cero		:= 0;
SET	Entero_Uno		:= 1;
SET	DecimalCero		:= 0.00;
SET	Salida_NO		:= 'N';
SET	SalidaSI		:= 'S';
SET Var_Activo      := 'A';
SET Cadena_NO		:= 'N';
SET Cadena_SI		:= 'S';

ManejoErrores:BEGIN

   	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
						'esto le ocasiona. Ref: SP-LOTETARJETADEBSAFIALT');
    END;

    -- VERIFICAR SI ESTA OCUPADO EL PROCESO
    SELECT EstatusProceso
        INTO  Var_EstatusProceso
    FROM TMPGENERALOTTARPRO;

    -- SI ESTA OCUPADO DEVOLVEMOS LA CLABE VACIA
    IF(Var_EstatusProceso = Var_Activo) THEN
            SET Par_NumErr      := 01;
            SET Par_ErrMen      := CONCAT('El Proceso se Encuentra Activo');
            SET Var_Consecutivo := Entero_Cero;
            SET Var_Control     := Cadena_Vacia;
        LEAVE ManejoErrores;
    END IF;

    -- SI ESTA INACTIVO ACTUALIZAMOS EL ESTATUS
    UPDATE   TMPGENERALOTTARPRO
        SET EstatusProceso = Var_Activo;

    IF(IFNULL(Par_TipoTarjetaDebID, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 001;
		SET Par_ErrMen := CONCAT('El Producto de Tarjeta esta Vacio.');
		SET Var_Control := 'tipoTarjetaDebID';
		LEAVE ManejoErrores;
	END IF;

    IF(IFNULL(Par_SucursalSolicita, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 002;
		SET Par_ErrMen := CONCAT('La Sucursal Solicitante esta Vacia.');
		SET Var_Control := 'sucursalSolicita';
		LEAVE ManejoErrores;
	END IF;

    IF(IFNULL(Par_NumTarjetas, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 003;
		SET Par_ErrMen := CONCAT('El Numero de Tarjetas esta Vacio.');
		SET Var_Control := 'numTarjetas';
		LEAVE ManejoErrores;
	END IF;

    IF(IFNULL(Par_EsAdicional, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 004;
		SET Par_ErrMen := CONCAT('El Tipo de Tarjetas esta Vacio.');
		SET Var_Control := 'esAdicional';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_ServiceCode, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 005;
		SET Par_ErrMen := CONCAT('El Código de Servicio Esta Vacio');
		SET Var_Control := 'catServiceCodeID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_EsPersonaliz, Cadena_Vacia)) NOT IN (Cadena_NO,Cadena_SI) THEN
		SET Par_NumErr := 006;
		SET Par_ErrMen := CONCAT('El Indicador Lote de Tarjetas Personalizado es Incorrecto');
		SET Var_Control := 'esPersonalizado';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_EsVirtual, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 007;
		SET Par_ErrMen := CONCAT('El Indicador Lote de Tarjetas Virtual es Incorrecto');
		SET Var_Control := 'catServiceCodeID';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_LoteDebitoSAFIID  = Entero_Cero) THEN
	 SELECT (MAX(LoteDebSAFIID)+1) INTO Var_LoteDebitoSAFIID
						FROM LOTETARJETADEBSAFI;
	ELSE
		SET Var_LoteDebitoSAFIID := Par_LoteDebitoSAFIID;

	    END IF;

	SET Var_LoteDebitoSAFIID:= IFNULL( Var_LoteDebitoSAFIID, Entero_Uno);
	SET Aud_FechaActual := NOW();
	SET Par_NomArchiGen := IFNULL( Par_NomArchiGen, Cadena_Vacia);
	SET Par_Estatus		:= Entero_Uno;

	INSERT INTO LOTETARJETADEBSAFI (
		LoteDebSAFIID,			TipoTarjetaDebID,		FechaRegistro,			SucursalSolicita,		UsuarioID,
		NumTarjetas,			Estatus,				EsAdicional,			RutaNomArch,			FolioInicial,
		FolioFinal,				BitCargaSAFIID,			ServiceCode,			EsPersonalizado,		EsVirtual,
		EmpresaID,				Usuario,				FechaActual,			DireccionIP,			ProgramaID,		
		Sucursal,				NumTransaccion)

	VALUES(
		Var_LoteDebitoSAFIID,	Par_TipoTarjetaDebID,	Par_FechaRegistro,		Par_SucursalSolicita,	Par_UsuarioID,
		Par_NumTarjetas,		Par_Estatus, 			Par_EsAdicional,		Par_NomArchiGen,		Par_FolioInicial,
		Par_FolioFinal,			Par_BitCargaID,			Par_ServiceCode,		Par_EsPersonaliz,		Par_EsVirtual,
		Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
		Aud_Sucursal,			Aud_NumTransaccion);

	    SET Par_NumErr := 000;
		SET Par_ErrMen := CONCAT('Lote de Tarjetas Agregado Exitosamente: ',Var_LoteDebitoSAFIID);
		SET Var_Control := 'loteDebitoSAFIID';
	    SET Var_Consecutivo	:= Var_LoteDebitoSAFIID;

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
	    SELECT  convert(Par_NumErr, CHAR(3)) AS NumErr,
	            Par_ErrMen AS ErrMen,
	            'loteDebitoSAFIID' AS control,
	            Var_Consecutivo AS consecutivo;
	end IF;
	
		IF (Par_Salida = Salida_NO) THEN
	    SELECT  Var_Consecutivo AS consecutivo;
	end IF;


END TerminaStore$$
