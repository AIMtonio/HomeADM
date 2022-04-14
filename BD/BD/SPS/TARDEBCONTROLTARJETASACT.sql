-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBCONTROLTARJETASACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBCONTROLTARJETASACT`;
DELIMITER $$


CREATE PROCEDURE `TARDEBCONTROLTARJETASACT`(
	Par_Bin 				VARCHAR(8),			-- Bin de la tarjeta
	Par_SubBin				VARCHAR(2),			-- SubBin de la tarjeta
	Par_CantTarjetas 		INT(11),			-- Cantidad a Incrementar
	Par_NumAct				INT(11),			-- Numero de Actualizacion
	
	Par_Salida				CHAR(1),			-- Campo a la qu hace referencia
    INOUT Par_NumErr		INT,				-- Parametro del numero de Error
    INOUT Par_ErrMen		VARCHAR(400),		-- Parametro del Mensaje de Error

    Aud_EmpresaID			INT(11),			-- Parametro de auditoria ID de la empresa
    Aud_Usuario				INT(11),			-- Parametro de auditoria ID del usuario
    Aud_FechaActual			DATETIME,			-- Parametro de auditoria Fecha actual
    Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria Direccion IP
    Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria Programa
    Aud_Sucursal			INT(11),			-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion 		BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN
	-- Declaracion de constantes.
	DECLARE	Entero_Cero			TINYINT;		-- Entero Vacio
	DECLARE	Cadena_Vacia		CHAR(1);		-- Cadena vacia
	DECLARE	Fecha_Vacia			DATE;			-- Fecha Vacia
	DECLARE	Salida_SI			CHAR(1);		-- Salida SI
	DECLARE Act_Decremento 		INT(11);		-- Decremento en cantidad de tarjetas
	DECLARE Act_Incremento 		INT(11);		-- Incremento en cantidad de tarjetas

	-- Declaracion de Variables
	DECLARE Var_CantTarjetas	INT(11);
	DECLARE Var_Control			VARCHAR(50);	-- Retorno de Control a Pantalla

	-- Asignacion de valor a constantes.
	SET	Entero_Cero				:= 0;				-- Entero Vacio
	SET	Cadena_Vacia			:= '';				-- Cadena Vacia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET	Salida_SI				:= 'S';				-- Salida SI
	SET Act_Decremento			:= 1;				-- Decremento en cantidad de tarjetas
	SET Act_Incremento 			:= 2;				-- Incremento en cantidad de tarjetas

	SET Par_Bin := IFNULL(Par_Bin, Cadena_Vacia);
	SET Par_SubBin := IFNULL(Par_SubBin, Cadena_Vacia);
	SET Par_CantTarjetas := IFNULL(Par_CantTarjetas, Entero_Cero);

	ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-AMORTIZAFONDEOSRACT');
		END;

		IF(Par_NumAct = Act_Decremento) THEN
			SELECT		CantTarjetas 
				INTO 	Var_CantTarjetas
				FROM TARDEBCONTROLTARJETAS
				WHERE Bin = Par_Bin
				AND SubBin = Par_SubBin;

			IF Var_CantTarjetas IS NULL THEN
				SET Par_NumErr		:= 1;
				SET Par_ErrMen		:= 'No se encontro informacion para cantidad de tarjetas con el Bin y SubBin proporcionados.';
				SET Var_Control		:= 'bin';
				LEAVE ManejoErrores;
			END IF;

			IF Var_CantTarjetas <= Entero_Cero THEN
				SET Par_NumErr		:= 2;
				SET Par_ErrMen		:= 'No existen numeros de tarjetas sin asignar para el Bin y SubBin proporcionados.';
				SET Var_Control		:= 'bin';
				LEAVE ManejoErrores;
			END IF;
			
			UPDATE TARDEBCONTROLTARJETAS
					SET CantTarjetas = CantTarjetas - 1
					WHERE Bin = Par_Bin
					AND SubBin = Par_SubBin;

			SET Par_NumErr		:=	0;
			SET Par_ErrMen		:=	CONCAT('Cantidad de tarjetas actualiza correctamente.');
			SET Var_Control		:=	'bin';

			LEAVE ManejoErrores;
		END IF;

		IF(Par_NumAct = Act_Incremento) THEN
			IF(Par_CantTarjetas = Entero_Cero) THEN
				SET Par_NumErr		:= 1;
				SET Par_ErrMen		:= 'Especifique la cantidad de tarjetas por actualizar.';
				SET Var_Control		:= 'cantTarjetas';
				LEAVE ManejoErrores;
			END IF;

			SELECT		CantTarjetas 
				INTO 	Var_CantTarjetas
				FROM TARDEBCONTROLTARJETAS
				WHERE Bin = Par_Bin
				AND SubBin = Par_SubBin;

			IF Var_CantTarjetas IS NULL THEN
				SET Par_NumErr		:= 2;
				SET Par_ErrMen		:= 'No se encontro informacion sobre la cantidad de tarjetas con el Bin y SubBin proporcionados.';
				SET Var_Control		:= 'bin';
				LEAVE ManejoErrores;
			END IF;

			UPDATE TARDEBCONTROLTARJETAS
					SET CantTarjetas = CantTarjetas + Par_CantTarjetas
					WHERE Bin = Par_Bin
					AND SubBin = Par_SubBin;

			SET Par_NumErr		:=	0;
			SET Par_ErrMen		:=	CONCAT('Cantidad de tarjetas actualiza correctamente.');
			SET Var_Control		:=	'bin';
		END IF;
	END ManejoErrores;

	IF(Par_Salida = Salida_SI) THEN
	    SELECT  Par_NumErr AS NumErr,
	            Par_ErrMen AS ErrMen,
				Cadena_Vacia AS control,
				Entero_Cero AS consecutivo;
	END IF;
END TerminaStore$$
