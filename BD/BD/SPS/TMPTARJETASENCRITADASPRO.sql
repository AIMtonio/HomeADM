-- TMPTARJETASENCRITADASPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPTARJETASENCRITADASPRO`;
DELIMITER $$

CREATE PROCEDURE `TMPTARJETASENCRITADASPRO`(
	/*SP de proceso para actualizar el num de Tarjeta con la Clave ya Encriptada.*/
	Par_Salida				CHAR(1),			-- Parametro que indica si hay salida
	INOUT Par_NumErr		INT(11),			-- Parametro para el numero de error
	INOUT Par_ErrMen		VARCHAR(400),		-- Parametro con el mensaje de error

	Aud_EmpresaID			INT(11),			-- Parametro de auditoria
	Aud_Usuario				INT(11),			-- Parametro de auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal			INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_Control			VARCHAR(30);	-- variable de control
	DECLARE Var_Consecutivo		BIGINT(12);		-- Variable para el consecutivo
	DECLARE Var_loteTarjetasID	INT(11);		-- Numero o ID del lote de tarjetas

	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia	CHAR(1);		-- Constante para cadena vacia
	DECLARE	Entero_Cero		INT(1);			-- Constante para entero cero
	DECLARE SalidaSI		CHAR(1); 		-- Constante Cadena Si
	DECLARE SalidaNo		CHAR(1); 		-- Constante Salida No
	DECLARE Est_Solicitud	INT(11);		-- Estatus solicitud del lote de tarjetas

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia 	:= '';				-- Constante para cadena vacia
	SET Entero_Cero		:= 0;				-- Constante para entero cero
	SET SalidaSI		:= 'S';				-- Constante Cadena Si
	SET SalidaNo		:= 'N';				-- Constante Salida No
	SET Est_Solicitud	:= 1;				-- Estatus solicitud del lote de tarjetas


	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-TMPTARJETASENCRITADASPRO');
			SET Var_Control:= 'SQLEXCEPTION' ;
		END;

		SELECT LoteDebSAFIID INTO Var_loteTarjetasID
			FROM LOTETARJETADEBSAFI
			WHERE Estatus = Est_Solicitud;

		-- Se actualiza el numero de la tarjeta con la tarjeta encriptada
		UPDATE BITACORATARJETA BITA
			INNER JOIN TMPTARJETASENCRITADAS TMP ON BITA.NumTarjeta = TMP.TarjetaCompleta  SET
			BITA.NumTarjeta = TMP.TarjetaEncriptada
		WHERE TMP.LoteTarjetasID = Var_loteTarjetasID;

		UPDATE TARLAYDEBSAFI TAR
		INNER JOIN TMPTARJETASENCRITADAS TMP ON TAR.NumTarjeta = TMP.TarjetaCompleta  SET
			TAR.NumTarjeta 		= TMP.TarjetaEncriptada
		WHERE TMP.LoteTarjetasID = Var_loteTarjetasID;

		UPDATE TARDEBASIGNADAS TAR
		INNER JOIN TMPTARJETASENCRITADAS TMP ON TAR.NumTarjeta = TMP.TarjetaCompleta SET
			TAR.NumTarjeta 		= TMP.TarjetaEncriptada
		WHERE TMP.LoteTarjetasID = Var_loteTarjetasID;

		SET Par_NumErr := 0;
		SET Par_ErrMen := 'Numero de Tarjeta Actualizado exitosamente';
		SET Var_Control := 'NumTarjeta';
		SET Var_Consecutivo := Entero_Cero;

	END ManejoErrores;
	-- SI LA SALIDA ES SI DEVUELVE EL MENSAJE DE EXITO
	IF (SalidaSI = SalidaSI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control	AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$