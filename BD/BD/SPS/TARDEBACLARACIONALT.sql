-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBACLARACIONALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBACLARACIONALT`;DELIMITER $$

CREATE PROCEDURE `TARDEBACLARACIONALT`(
#SP PARA ALTA DE ACLARACIONES TARJETA
    Par_TipoReporte     INT(11),		-- Parametro de tipo reporte
    Par_TarjetaDebID    CHAR(16), 		-- Parametro de tarjeta ID
    Par_TipoTarjeta		CHAR(1),		-- Parametro de tipo tarjeta
    Par_InstitucionID   INT(11),		-- Parametro de institucion ID
    Par_OperacionID     INT(11),		-- Parametro de operacion ID
    Par_TiendaComercio  VARCHAR(150),	-- Parametro de tienda comercio
    Par_CajeroID        VARCHAR(10),	-- Parametro de cajero ID
    Par_MontoOperacion  DECIMAL(12,2),	-- Parametro de monto operacion
    Par_FechaOperacion  DATETIME,		-- Parametro de fecha operacion
    Par_NumTransaccion  BIGINT(20),		-- Parametro de numero transaccion
    Par_DetalleReporte  VARCHAR(2000),	-- Parametro de detalle reporte
	Par_NumAutorizacion	BIGINT(20),		-- Parametro de numero autorizacion

    Par_Salida          CHAR(1),		-- Parametro de salida
    INOUT Par_NumErr    INT,			-- Parametro de numero error
    INOUT Par_ErrMen    VARCHAR(200),	-- Parametro de mensaje error

    Aud_EmpresaID       INT(11),		-- Parametro de Auditoria
    Aud_Usuario         INT(11),		-- Parametro de Auditoria
    Aud_FechaActual     DATETIME,		-- Parametro de Auditoria
    Aud_DireccionIP     VARCHAR(15),	-- Parametro de Auditoria
    Aud_ProgramaID      VARCHAR(50),	-- Parametro de Auditoria
    Aud_Sucursal        INT(11),		-- Parametro de Auditoria
    Aud_NumTransaccion  BIGINT(20)		-- Parametro de Auditoria

	)
TerminaStore: BEGIN

DECLARE Cadena_Vacia    CHAR(1);			-- Cadena vacia
DECLARE Entero_Cero     INT; 				-- entero cero
DECLARE Decimal_Cero    DECIMAL(12,2);		-- DECIMAL cero
DECLARE SalidaSI        CHAR(1);			-- salida si
DECLARE SalidaNO        CHAR(1);			-- salida no
DECLARE Par_ReporteID   INT(11);			-- reporte id
DECLARE Estatus_Alta    CHAR(1);			-- estatus alta
DECLARE Var_TarjetaDebID    CHAR(16);		-- variabel de tarjeta ID
DECLARE varControl		VARCHAR(50);		-- variable control
DECLARE TipoCred		CHAR(1);			-- tipo credito
DECLARE TipoDeb			CHAR(1);			-- tipo debito


SET Cadena_Vacia    := '';
SET Entero_Cero     := 0;
SET SalidaSI        := 'S';
SET SalidaNO        := 'N';
SET Aud_FechaActual := CURRENT_TIMESTAMP();
SET Estatus_Alta    := 'A';
SET TipoCred		:= 'C';
SET TipoDeb			:= 'D';

ManejoErrores:BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
						'esto le ocasiona. Ref: SP-TARDEBACLARACIONALT');
    END;
	IF(Par_TipoTarjeta = TipoDeb)THEN
		SET Var_TarjetaDebID := (SELECT tar.TarjetaDebID FROM TARJETADEBITO tar WHERE tar.TarjetaDebID = Par_TarjetaDebID);
    END IF;
    IF(Par_TipoTarjeta = TipoCred)THEN
		SET Var_TarjetaDebID := (SELECT tar.TarjetaCredID FROM TARJETACREDITO tar WHERE tar.TarjetaCredID = Par_TarjetaDebID);
    END IF;
	IF (Var_TarjetaDebID = Par_TarjetaDebID) THEN
		IF(IFNULL(Par_TipoReporte,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'Especifique el Tipo de Reporte';
			SET varControl  := 'reporte' ;
			LEAVE ManejoErrores;
		END IF;
        IF(IFNULL(Par_TipoTarjeta,Cadena_Vacia))= Cadena_Vacia THEN
			SET Par_NumErr  := 002;
			SET Par_ErrMen  := 'Especifique el Tipo de Tarjeta';
			SET varControl  := 'tipoTarjetaD' ;
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
			SET varControl  := 'operacion' ;
			LEAVE ManejoErrores;
		END IF;
        IF(IFNULL(Par_MontoOperacion,Decimal_Cero))= Decimal_Cero THEN
			SET Par_NumErr  := 005;
			SET Par_ErrMen  := 'Especifique el Monto';
			SET varControl  := 'monto' ;
			LEAVE ManejoErrores;
		END IF;
        IF(IFNULL(Par_DetalleReporte,Cadena_Vacia))= Cadena_Vacia THEN
			SET Par_NumErr  := 006;
			SET Par_ErrMen  := 'Especifique el Detalle del Reporte';
			SET varControl  := 'detalle' ;
			LEAVE ManejoErrores;
		END IF;


        CALL FOLIOSAPLICAACT('TARDEBACLARACION', Par_ReporteID);

        INSERT INTO TARDEBACLARACION(
            ReporteID,      	TipoAclaraID,       TarjetaDebID,       TipoTarjeta,		InstitucionID,
            OpeAclaraID,		Comercio,			NoCajero,           FechaOperacion,     MontoOperacion,
            TransaccionRep, 	DetalleReporte,  	UsuarioRegistra,    FechaAclaracion,    Estatus,
            UsuarioResolucion,  FechaResolucion,	NoAutorizacion, 	EmpresaID,          Usuario,
            FechaActual,        DireccionIP,        ProgramaID,			Sucursal,			NumTransaccion)
        VALUES (
            Par_ReporteID,      Par_TipoReporte,    Par_TarjetaDebID,   Par_TipoTarjeta,	Par_InstitucionID,
            Par_OperacionID,	Par_TiendaComercio, Par_CajeroID,       Par_FechaOperacion, Par_MontoOperacion,
            Par_NumTransaccion, Par_DetalleReporte, Aud_Usuario,        Aud_FechaActual,    Estatus_Alta,
            Entero_Cero,        Aud_FechaActual,    Par_NumAutorizacion,Aud_EmpresaID,      Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,   	Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

		SET Par_NumErr  := 000;
		SET Par_ErrMen  := CONCAT('Aclaracion Agregada Exitosamente: ', Par_ReporteID);
		SET varControl  := 'reporteID' ;
		LEAVE ManejoErrores;
    END IF;
END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				varControl AS control,
				Par_ReporteID AS consecutivo;
	END IF;

END TerminaStore$$