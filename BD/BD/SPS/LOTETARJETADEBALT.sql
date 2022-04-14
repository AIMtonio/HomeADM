-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LOTETARJETADEBALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `LOTETARJETADEBALT`;DELIMITER $$

CREATE PROCEDURE `LOTETARJETADEBALT`(

	Par_LoteDebitoID		INT(11),
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
	Par_Salida				CHAR(1),
	INOUT Par_NumErr    	INT,
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

DECLARE Var_Control			VARCHAR(50);
DECLARE Var_Consecutivo		INT;


DECLARE	Cadena_Vacia	 CHAR(1);
DECLARE	Entero_Cero		 INT;
DECLARE Entero_Uno		 INT;
DECLARE	DecimalCero		 DECIMAL(12,2);
DECLARE Salida_NO 		 CHAR(1);
DECLARE	SalidaSI	 	 CHAR(1);
DECLARE Var_LoteDebitoID INT;


SET	Cadena_Vacia	:= '';
SET	Entero_Cero		:= 0;
SET	Entero_Uno		:= 1;
SET	DecimalCero		:= 0.00;
SET	Salida_NO		:= 'N';
SET	SalidaSI		:= 'S';

ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
						'esto le ocasiona. Ref: SP-LOTETARJETADEBALT');
    END;

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

IF(Par_LoteDebitoID  = Entero_Cero) THEN
 SELECT (MAX(LoteDebitoID)+1) INTO Var_LoteDebitoID
					FROM LOTETARJETADEB;
ELSE
	SET Var_LoteDebitoID=Par_LoteDebitoID;

    END IF;

SET Var_LoteDebitoID:= IFNULL( Var_LoteDebitoID, Entero_Uno);
SET Aud_FechaActual := NOW();
SET Par_NomArchiGen := IFNULL( Par_NomArchiGen, Cadena_Vacia);
SET Par_Estatus		:= Entero_Uno;

INSERT INTO LOTETARJETADEB (
	LoteDebitoID,	TipoTarjetaDebID,	FechaRegistro,	SucursalSolicita,	UsuarioID,	NumTarjetas,	Estatus,
    EsAdicional,	NomArchiGen,		FolioInicial,	FolioFinal,			BitCargaID,	EmpresaID,		Usuario,
    FechaActual,	DireccionIP,		ProgramaID,		Sucursal,		NumTransaccion)

VALUES(
	Var_LoteDebitoID,	Par_TipoTarjetaDebID,	Par_FechaRegistro,	Par_SucursalSolicita,	Par_UsuarioID,		Par_NumTarjetas,
    Par_Estatus, 		Par_EsAdicional,		Par_NomArchiGen,	Par_FolioInicial,		Par_FolioFinal,		Par_BitCargaID,
    Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
    Aud_NumTransaccion);

    SET Par_NumErr := 000;
	SET Par_ErrMen := CONCAT('Lote de Tarjetas Agregado Exitosamente: ',Var_LoteDebitoID);
	SET Var_Control := 'TipoTarjetaDebID';
    SET Var_Consecutivo	:= Var_LoteDebitoID;

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  convert(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            'TipoTarjetaDebID' AS control,
            Var_Consecutivo AS consecutivo;
end IF;


END TerminaStore$$