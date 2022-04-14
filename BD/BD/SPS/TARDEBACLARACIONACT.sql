-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBACLARACIONACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBACLARACIONACT`;DELIMITER $$

CREATE PROCEDURE `TARDEBACLARACIONACT`(
-- ACTUALIZA EL ESTATUS DE UNA ACLARACION
    Par_TipoReporte     INT(11),		-- Parametro de Tipo Reporte
    Par_NoReporte       INT(11),		-- Parametro numero reporte
    Par_TarjetaDebID    CHAR(16),		-- Parametro tarjeta ID
    Par_TipoTarjeta		CHAR(1),		-- Parametro de tipo tarjeta
    Par_InstitucionID   INT(11),		-- Parametro de institucion ID
    Par_OperacionID     INT(11),		-- Parametro operacion ID
    Par_TiendaComercio  VARCHAR(150),	-- Parametro de tienda comercio
    Par_CajeroID        VARCHAR(10),	-- Parametro cajero ID
    Par_MontoOperacion  DECIMAL(12,2),	-- Parametro monto operacion
    Par_FechaOperacion  DATETIME,		-- Parametro fecha operacion
    Par_NumTransaccion  BIGINT(20),		-- Parametro numero transaccion
    Par_DetalleReporte  VARCHAR(2000),	-- Parametro detalle reporte
	Par_NumAutorizacion	BIGINT(20),		-- Parametro numero autorizacion

    Par_Salida          CHAR(1),		-- Parametro salida
    INOUT Par_NumErr    INT,			-- Parametro numero error
    INOUT Par_ErrMen    VARCHAR(200),	-- Parametro error mensaje

    Aud_EmpresaID       INT(11),		-- Parametro de Auditoria
    Aud_Usuario         INT(11),		-- Parametro de Auditoria
    Aud_FechaActual     DATETIME,		-- Parametro de Auditoria
    Aud_DireccionIP     VARCHAR(15),	-- Parametro de Auditoria
    Aud_ProgramaID      VARCHAR(50),	-- Parametro de Auditoria
    Aud_Sucursal        INT(11),		-- Parametro de Auditoria
    Aud_NumTransaccion  BIGINT(20)		-- Parametro de Auditoria

	)
TerminaStore: BEGIN

	DECLARE Cadena_Vacia    CHAR(1);		-- cadena vacia
	DECLARE Entero_Cero     INT; 			-- entero cero
	DECLARE Decimal_Cero    DECIMAL(12,2);	-- DECIMAL cero
	DECLARE SalidaSI        CHAR(1);		-- salida si
	DECLARE SalidaNO        CHAR(1);		-- salida no
	DECLARE Par_ReporteID   INT(11);		-- reporte ID
	DECLARE Estatus_Alta    CHAR(1);		-- estatus alta
	DECLARE Var_TarDebID	VARCHAR(16);	-- variable de tarjeta ID
    DECLARE varControl 		CHAR(15);		# almacena el elemento que es incorrecto
    DECLARE TipoCred		CHAR(1);		-- tipo credito
	DECLARE TipoDeb			CHAR(1);		-- tipo debito

	-- Asignacion  de constantes
	SET Cadena_Vacia    := '';              -- Cadena o string vacio
	SET Entero_Cero     := 0;               -- Entero en cero
	SET SalidaSI        := 'S';             -- El Store SI genera una Salida
	SET SalidaNO        := 'N';				-- El Store NO genera una Salida
	SET Aud_FechaActual := CURRENT_TIMESTAMP();
	SET Estatus_Alta    := 'A';             -- indica que el estatus del reporte es Alta
    SET TipoCred		:= 'C';
	SET TipoDeb			:= 'D';

ManejoErrores:BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
						'esto le ocasiona. Ref: SP-TARDEBACLARACIONACT');
    END;

	IF(Par_TipoTarjeta = TipoDeb)THEN
		SET Var_TarDebID = (SELECT TarjetaDebID FROM TARJETADEBITO WHERE TarjetaDebID = Par_TarjetaDebID);
    END IF;
    IF(Par_TipoTarjeta = TipoCred)THEN
		SET Var_TarDebID = (SELECT TarjetaCredID FROM TARJETACREDITO WHERE TarjetaCredID = Par_TarjetaDebID);
    END IF;

    IF (Var_TarDebID = Par_TarjetaDebID) THEN
		IF(IFNULL(Par_TipoReporte,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'Especifique el Tipo de Reporte';
			SET varControl  := 'tipoReporte' ;
			LEAVE ManejoErrores;
		END IF;
        IF(IFNULL(Par_TarjetaDebID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := 002;
			SET Par_ErrMen  := 'Especifique el Numero de Tarjeta';
			SET varControl  := 'tarjetaDebID' ;
			LEAVE ManejoErrores;
		END IF;
		IF(IFNULL(Par_InstitucionID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := 003;
			SET Par_ErrMen  := 'Especifique el Numero de Institucion';
			SET varControl  := 'institucionID' ;
			LEAVE ManejoErrores;
		END IF;
		IF(IFNULL(Par_OperacionID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := 004;
			SET Par_ErrMen  := 'Especifique el Tipo de Operacion';
			SET varControl  := 'operacionID' ;
			LEAVE ManejoErrores;
		END IF;
		IF(IFNULL(Par_MontoOperacion,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := 005;
			SET Par_ErrMen  := 'Especifique el Monto';
			SET varControl  := 'montoOperacion' ;
			LEAVE ManejoErrores;
		END IF;
		IF(IFNULL(Par_DetalleReporte,Cadena_Vacia))= Cadena_Vacia THEN
			SET Par_NumErr  := 006;
			SET Par_ErrMen  := 'Especifique el Detalle del Reporte';
			SET varControl  := 'detalleReporte' ;
			LEAVE ManejoErrores;
		END IF;

        UPDATE TARDEBACLARACION SET
            InstitucionID       = Par_InstitucionID,
            OpeAclaraID         = Par_OperacionID,
            Comercio            = Par_TiendaComercio,
            NoCajero            = Par_CajeroID,
            FechaOperacion      = Par_FechaOperacion,
            MontoOperacion      = Par_MontoOperacion,
            TransaccionRep      = Par_NumTransaccion,
            DetalleReporte      = Par_DetalleReporte,
            UsuarioRegistra     = Aud_Usuario,
            FechaAclaracion     = Aud_FechaActual,
			NoAutorizacion		= Par_NumAutorizacion,
            Estatus             = Estatus_Alta,
            UsuarioResolucion   = Entero_Cero,
            FechaResolucion     = Aud_FechaActual,

            EmpresaID           = Aud_EmpresaID,
            Usuario             = Aud_Usuario,
            FechaActual         = Aud_FechaActual,
            DireccionIP         = Aud_DireccionIP,
            ProgramaID          = Aud_ProgramaID,
            Sucursal            = Aud_Sucursal,
            NumTransaccion      = Aud_NumTransaccion
        WHERE ReporteID = Par_NoReporte
		AND TipoAclaraID= Par_TipoReporte
		AND TarjetaDebID = Par_TarjetaDebID;

        SET Par_NumErr  := 000;
			SET Par_ErrMen  := CONCAT('Aclaracion Modificada Exitosamente: ', Par_NoReporte);
			SET varControl  := 'reporteID' ;
			LEAVE ManejoErrores;
    END IF;
END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				varControl AS control,
				Par_NoReporte AS consecutivo;
	END IF;

END TerminaStore$$