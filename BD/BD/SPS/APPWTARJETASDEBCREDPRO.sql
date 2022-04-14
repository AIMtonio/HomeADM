-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APPWTARJETASDEBCREDPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `APPWTARJETASDEBCREDPRO`;

DELIMITER $$
CREATE PROCEDURE `APPWTARJETASDEBCREDPRO`(

	Par_TarjetaID			VARCHAR(16),
	Par_TipoOpera			CHAR(1),

	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),

	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)

TerminaStore: BEGIN


	DECLARE Var_Control			VARCHAR(50);
	DECLARE Var_TarjetaDebID	VARCHAR(16);
	DECLARE Var_TarjetaCredID	VARCHAR(16);
	DECLARE Var_Estatus			INT(11);



	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Entero_Cero			INT(11);
	DECLARE Entero_Uno			INT(11);
	DECLARE Con_SalidaSI		CHAR(1);
	DECLARE Act_BloqDesBloq		INT(11);


	SET Cadena_Vacia			:= '';
	SET Fecha_Vacia				:= '1900-01-01';
	SET Entero_Cero				:= 0;
	SET Con_SalidaSI			:= 'S';
	SET Act_BloqDesBloq			:= 1;

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr  := 999;
				SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
											'esto le ocasiona. Ref: SP-APPWTARJETASDEBCREDPRO');
				SET Var_Control := 'SQLEXCEPTION';
			END;

		IF(Par_TarjetaID = Cadena_Vacia) THEN
			SET Par_NumErr		:=	1;
			SET Par_ErrMen		:=	'El campo Numero de tarjeta se encuentra vacio';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TipoOpera = Cadena_Vacia) THEN
			SET Par_NumErr		:=	2;
			SET Par_ErrMen		:=	'El campo tipo de operacion se encuentra vacio';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TipoOpera <> '1' AND Par_TipoOpera <> '0') THEN
			SET Par_NumErr		:=	3;
			SET Par_ErrMen		:=	'El tipo de operacion es incorecta';
			SET Var_Control		:=	'Numero Tarjeta';
			LEAVE ManejoErrores;
		END IF;

		SELECT TarjetaDebID, Estatus INTO Var_TarjetaDebID,Var_Estatus FROM TARJETADEBITO WHERE TarjetaDebID = Par_TarjetaID;

		SET Var_TarjetaDebID := IFNULL(Var_TarjetaDebID, Cadena_Vacia);

		IF(Var_TarjetaDebID <> Cadena_Vacia) THEN

			IF(Par_TipoOpera = '0') THEN

				IF(Var_Estatus = 8) THEN
					SET Par_NumErr		:=	4;
					SET Par_ErrMen		:=	'El Numero de la tarjeta ya se encuentra apagada';
					LEAVE ManejoErrores;
				END IF;

				UPDATE TARJETADEBITO
					SET Estatus = 8,

						EmpresaID= Aud_EmpresaID,
						Usuario=Aud_Usuario,
						FechaActual =Aud_FechaActual,
						DireccionIP=Aud_DireccionIP,
						ProgramaID =Aud_ProgramaID,
						Sucursal=Aud_Sucursal,
						NumTransaccion =Aud_NumTransaccion
					WHERE TarjetaDebID = Var_TarjetaDebID;

				SET Par_NumErr		:=	0;
				SET Par_ErrMen		:=	'Tarjeta Apagada Exitosamete';

			ELSE


				IF(Var_Estatus = 7) THEN
					SET Par_NumErr		:=	5;
					SET Par_ErrMen		:=	'El Numero de la tarjeta ya se encuentra encendida';
					LEAVE ManejoErrores;
				END IF;

				UPDATE TARJETADEBITO
					SET Estatus = 7,
						EmpresaID= Aud_EmpresaID,
						Usuario=Aud_Usuario,
						FechaActual =Aud_FechaActual,
						DireccionIP=Aud_DireccionIP,
						ProgramaID =Aud_ProgramaID,
						Sucursal=Aud_Sucursal,
						NumTransaccion =Aud_NumTransaccion
					WHERE TarjetaDebID = Var_TarjetaDebID;

				SET Par_NumErr		:=	0;
				SET Par_ErrMen		:=	'Tarjeta Encendida Exitosamete';

			END IF;
		ELSE
			SELECT TarjetaDebID, Estatus INTO Var_TarjetaCredID,Var_Estatus FROM TARJETACREDITO WHERE TarjetaDebID = Par_TarjetaID;

			IF(Par_TipoOpera = '0') THEN

				IF(Var_Estatus = 8) THEN
					SET Par_NumErr		:=	6;
					SET Par_ErrMen		:=	'El Numero de la tarjeta ya se encuentra apagada';
					LEAVE ManejoErrores;
				END IF;

				UPDATE TARJETACREDITO
					SET Estatus = 8,
						EmpresaID= Aud_EmpresaID,
						Usuario=Aud_Usuario,
						FechaActual =Aud_FechaActual,
						DireccionIP=Aud_DireccionIP,
						ProgramaID =Aud_ProgramaID,
						Sucursal=Aud_Sucursal,
						NumTransaccion =Aud_NumTransaccion
					WHERE TarjetaDebID = Var_TarjetaCredID;

				SET Par_NumErr		:=	0;
				SET Par_ErrMen		:=	'Tarjeta Apagada Exitosamete';

			ELSE

				IF(Var_Estatus = 11) THEN
					SET Par_NumErr		:=	7;
					SET Par_ErrMen		:=	'El Numero de la tarjeta ya se encuentra encendida';
					LEAVE ManejoErrores;
				END IF;


				UPDATE TARJETACREDITO
					SET Estatus = 11,
						EmpresaID= Aud_EmpresaID,
						Usuario=Aud_Usuario,
						FechaActual =Aud_FechaActual,
						DireccionIP=Aud_DireccionIP,
						ProgramaID =Aud_ProgramaID,
						Sucursal=Aud_Sucursal,
						NumTransaccion =Aud_NumTransaccion
					WHERE TarjetaDebID = Var_TarjetaCredID;

				SET Par_NumErr		:=	0;
				SET Par_ErrMen		:=	'Tarjeta Encendida Exitosamete';

			END IF;

		END IF;


	END ManejoErrores;

	IF (Par_Salida = Con_SalidaSI) THEN
		SELECT 	Par_NumErr 		AS NumErr,
				Par_ErrMen 		AS ErrMen,
				Var_Control 	AS Control;
    END IF;


END TerminaStore$$