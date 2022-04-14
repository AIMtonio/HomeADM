-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBACTIVARALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBACTIVARALT`;DELIMITER $$

CREATE PROCEDURE `TARDEBACTIVARALT`(
#SP DE ACTIVACION DE TARJETA
	Par_TarjetaDebID		CHAR(16),		-- Parametro de Tarjeta Debito ID

	Par_Salida				CHAR(1),		-- Parametro de Salida
	INOUT	Par_NumErr		INT(11),		-- Numero de Error
	INOUT	Par_ErrMen		VARCHAR (350),	-- Mensaje Error

	Aud_EmpresaID		  	INT(11),		-- Parametro de Auditoria
	Aud_Usuario				INT(11),		-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal			INT(11),		-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT			-- Parametro de Auditoria
			)
TerminaStore: BEGIN
-- variables
DECLARE Var_EstatusTar  	INT(11);		-- Variable de Estatus Tarjeta
DECLARE Var_FechaOper		DATE;			-- Variable de Fecha Operacion
DECLARE Var_NombreCliente	VARCHAR(200);	-- Variable de Nombre Cliente
-- Constantes
DECLARE Transaccion  	   	CHAR(1);		-- Transaccion
DECLARE	Cadena_Vacia		CHAR(1);		-- Cadena Vacia
DECLARE	Entero_Cero			INT;			-- Entero Cero
DECLARE SalidaSI			CHAR(1);		-- Salida Si
DECLARE SalidaNO			CHAR(1);		-- Salida No
DECLARE Estatus_Asig		INT;			-- Estatus Asignacion
DECLARE Estatus_Act			INT;			-- Estatus Activo
DECLARE Actualiza			INT;			-- Actualizar
DECLARE Desc_Estatus		VARCHAR(100);	-- Leyenda Estatus
DECLARE varControl			VARCHAR(50);	-- Variable de Control
-- Asignacion de Constantes
SET	Cadena_Vacia		:= '';
SET	Entero_Cero			:= 0;
SET SalidaSI			:='S';
SET SalidaNO      		:= 'N';
SET Estatus_Asig	   	:= 6; -- Estatus de Tarjeta Asignada a Cliente
SET Actualiza 			:=2;  -- Para actualizar el estatus en La Tabla de MEM_TARJETADEBITO,haciendo la llamada al store de TARDEBMEMORY
SET Desc_Estatus		:='Tarjeta Activada'; -- Corresponde del estatus de la tarjeta en la tabla de ESTATUSTD
SET Estatus_Act			:= 7; -- Estatus de Tarjeta activada
-- Busca que estatus Tiene La Tarjeta en La Tabla TARJETADEBITO

ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
						'esto le ocasiona. Ref: SP-TARDEBACTIVARALT');
    END;

    SET Var_EstatusTar 		:= (SELECT tar.Estatus FROM TARJETADEBITO tar WHERE tar.TarjetaDebID = Par_TarjetaDebID);
	SET Var_FechaOper   	:= (SELECT FechaSistema FROM PARAMETROSSIS);
    SET Var_NombreCliente 	:= (SELECT Cli.NombreCompleto FROM CLIENTES Cli
									INNER JOIN TARJETADEBITO Tar ON Tar.ClienteID=Cli.ClienteID
								WHERE Tar.TarjetaDebID=Par_TarjetaDebID);

	IF (Var_EstatusTar = Estatus_Asig ) THEN
		IF(IFNULL(Par_TarjetaDebID,Cadena_Vacia))= Cadena_Vacia THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'El Numero de Tarjeta esta Vacio';
			SET varControl  := 'tarjetaID' ;
			LEAVE ManejoErrores;
		END IF;
	END IF;

	-- Se Inserta Un Registro en la Tabla de BITACORATARDEB
	CALL BITACORATARDEBALT(
			Par_TarjetaDebID,	Estatus_Act,		Entero_Cero,		Desc_Estatus,		Var_FechaOper,
			Var_NombreCliente,	Par_Salida,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

    IF (Par_NumErr != Entero_Cero) THEN
		SET Par_NumErr := 02;
		SET Par_ErrMen := 'Error al realizar alta bitacora tarjeta.';
		LEAVE ManejoErrores;
	END IF;
	-- Se actualiza el Estatus en la Tabla de TARJETADEBITO
	UPDATE TARJETADEBITO SET
			FechaActivacion	   = Var_FechaOper,
			Estatus  		   = Estatus_Act
		WHERE TarjetaDebID = Par_TarjetaDebID;

			SET Par_NumErr  := 000;
			SET Par_ErrMen  := CONCAT('Tarjeta: ', Par_TarjetaDebID, ' Activada Exitosamente');
			SET varControl  := 'tipoTarjetaD' ;
			LEAVE ManejoErrores;

END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				varControl AS control,
				Par_TarjetaDebID AS consecutivo;
	END IF;


END TerminaStore$$