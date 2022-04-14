-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APPWSMSVERIFICACIONCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `APPWSMSVERIFICACIONCON`;

DELIMITER $$
CREATE PROCEDURE `APPWSMSVERIFICACIONCON`(



    Par_Codigo				VARCHAR(50),
    Par_NumTransaccion		BIGINT,
    Par_NumTelefono			VARCHAR(20),
    Par_TiempoValSMS		INT(11),
    Par_NumCon				INT(1),

	Par_EmpresaID       	INT(11),
    Aud_Usuario         	INT(11),
    Aud_FechaActual     	DATETIME,
    Aud_DireccionIP     	VARCHAR(15),
    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal        	INT(11),
    Aud_NumTransaccion  	BIGINT(20)
)

TerminaStore: BEGIN


    DECLARE Codigo_Respuesta	CHAR(3);
    DECLARE Mensaje_Respuesta	CHAR(200);


	DECLARE Con_Verificacion	INT;
    DECLARE Con_Valid_Cod	    INT;
    DECLARE Fecha_Actual	    DATETIME;
	DECLARE Min_Max_Dif		    INT;
    DECLARE Out_ID_Envio		INT(11);
    DECLARE Cadena_Vacia		CHAR(1);


	SET Con_Valid_Cod		:= 1;
	SET	Con_Verificacion	:= 2;
    SET Fecha_Actual 		:= NOW();
    SET Cadena_Vacia		:= '';


	IF (Par_NumCon = Con_Valid_Cod) THEN

		 SELECT EnvioID INTO Out_ID_Envio FROM APPWSMSVERIFICACION WHERE Receptor = Par_numTelefono
				AND TIMESTAMPDIFF(MINUTE, FechaRealEnvio, Fecha_Actual)   < Par_TiempoValSMS
                AND  Codigo = Par_Codigo
				ORDER BY FechaActual DESC LIMIT 1;

				IF(IFNULL(Out_ID_Envio, Cadena_Vacia)) = Cadena_Vacia THEN
					SET	Codigo_Respuesta 	:= '002';
					SET	Mensaje_Respuesta	:= 'El Mensaje de Activacion No Existe o Caduco';
				ELSE
					SET	Codigo_Respuesta 	:= '000';
					SET	Mensaje_Respuesta	:= 'Linea Verificada Exitosamente';
				END IF;

	END IF;


	IF (Par_NumCon = Con_Verificacion) THEN

            SELECT EnvioID INTO Out_ID_Envio FROM APPWSMSVERIFICACION WHERE Receptor = Par_numTelefono
				AND TIMESTAMPDIFF(MINUTE, FechaProgEnvio, Fecha_Actual)  < Par_TiempoValSMS ORDER BY FechaActual DESC LIMIT 1;

				IF(IFNULL(Out_ID_Envio, Cadena_Vacia)) = Cadena_Vacia THEN
					SET	Codigo_Respuesta 	:= '000';
					SET	Mensaje_Respuesta	:= 'Exito Sin SMS de Activacion Activos';
				ELSE
					SET	Codigo_Respuesta 	:= '001';
					SET	Mensaje_Respuesta	:= 'Previamente Te Hemos Enviado un SMS con un Codigo de Activacion, Intenta mas Tarde';
				END IF;
	END IF;

    SELECT Codigo_Respuesta, Mensaje_Respuesta;
END TerminaStore$$