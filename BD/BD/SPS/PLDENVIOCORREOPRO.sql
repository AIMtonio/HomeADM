-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDENVIOCORREOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDENVIOCORREOPRO`;
DELIMITER $$


CREATE PROCEDURE `PLDENVIOCORREOPRO`(
/* STORE DE PROCESO QUE REGISTRA LOS CORREOS A ENVIAR DE
 * LAS OPERACIONES INUSUALES DETECTADAS AL CIERRE */
	Par_Fecha			DATETIME,		-- Fecha de Deteccion/Registro
	Par_Salida			CHAR(1),		-- Indica el tipo de Salida S.- Si N.- No
	INOUT Par_NumErr   	INT(11),		-- Numero de Error
	INOUT Par_ErrMen   	VARCHAR(400),	-- Mensaje de Error
	/* Parametros de Auditoria */
	Par_EmpresaID		INT(11),

	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),

	Aud_NumTransaccion	BIGINT(20)
)

TerminaStore:BEGIN

-- Declaracion de Variables
DECLARE	Var_OperacionID			INT(11);
DECLARE	Var_NumRows				INT(11);
DECLARE	Var_Contador			INT(11);
DECLARE	Var_Persona				VARCHAR(200);
DECLARE	Var_FechaDeteccion		DATE;
DECLARE	Var_FechaOperacion		DATE;
DECLARE	Var_DesOperacion  		VARCHAR(300);
DECLARE Var_Remitente			VARCHAR(50);
DECLARE Var_DestinatarioPLD		VARCHAR(50);
DECLARE	Var_ServidorCorreo		VARCHAR(30);
DECLARE	Var_Puerto				VARCHAR(10);
DECLARE	Var_Contrasenia			VARCHAR(20);
DECLARE	Var_UsuarioCorreo		VARCHAR(50);
DECLARE Var_MensajeTemporal		TEXT;
DECLARE	Var_NombreCompleto		VARCHAR(200);
DECLARE	Var_ColorBG				VARCHAR(20);
DECLARE	Var_VersionSAFI			VARCHAR(200);
DECLARE	Var_ClavePersonaInv		INT(11);
DECLARE	Var_PieMensaje			VARCHAR(600);
DECLARE Var_RemitenteID			INT(11);

-- Declaracion de Variables--------
DECLARE	Con_Mensaje				TEXT;
DECLARE	Con_MensajeDes			TEXT;
DECLARE	Con_MensajeEnviar		TEXT;
DECLARE	Con_MensajeDesExt		TEXT;
DECLARE	Con_MensajeEnviarExt	TEXT;
DECLARE MensajeTMP				TEXT;
DECLARE Tam_Mensaje				INT;

-- Declaracion de Constantes-----------
DECLARE	Con_Asunto			VARCHAR(150);
DECLARE	Entero_Cero			INT;
DECLARE	LimiteMsg			INT(11);
DECLARE	LimiteExtra			INT(11);
DECLARE Con_CatMotivInuID	VARCHAR(15);
DECLARE Cadena_Vacia		CHAR(1);
DECLARE SalidaNO			CHAR(1);
DECLARE SalidaSI			CHAR(1);
DECLARE Fecha_Vacia			DATE;
DECLARE Var_ProcesoPld		VARCHAR(50);

DECLARE  CURSORENVIOMENSAJE  CURSOR FOR
	SELECT
		OpeInusualID, NomPersonaInv,Fecha, DesOperacion,ClavePersonaInv,
		FechaDeteccion
			FROM PLDOPEINUSUALES
				WHERE FechaDeteccion = Par_Fecha
				ORDER BY OpeInusualID;

DECLARE CURSORENVIOCORREO CURSOR FOR
	SELECT Mensaje FROM TMPENVIOCORREOPLD;

-- Asignacion de Variables-------------------
SET Con_Asunto			:='Alertas Inusuales PLD.';-- Asunto del Mensaje
SET	Con_MensajeDes		:='';			-- tds del mensaje
SET Entero_Cero			:=0;			-- Constante Cero
SET	Var_OperacionID 	:=0;			-- Numero de la operacion de PLD;
SET	Var_Contador	 	:=1;			-- Numero CONTADOR;
SET	LimiteMsg		 	:=64000;		-- Longitud Limite del Mensaje
SET	LimiteExtra		 	:=1138;			-- Longitud Limite del Mensaje EXTRA
SET Con_MensajeEnviar	:='';			-- Mensaje completo a  Enviar
SET Con_MensajeDesExt	:='';			-- tds del mensaje extra
SET Con_MensajeEnviarExt:='';			-- Mensaje completo a  Enviar Extra
SET Con_CatMotivInuID	:='SIS1';		-- Categoria Deteccion por Sistema Mediante el cierre
SET Cadena_Vacia		:='';			-- Cadena Vacia
SET SalidaNO			:='N';			-- Salida No
SET SalidaSI			:='S';			-- Salida SI
SET Tam_Mensaje			:= 0;			-- Tamaño del mensaje actual por registro de operacion + El mensaje total concatenado
SET Con_Mensaje 		:= Cadena_Vacia;
SET Var_MensajeTemporal := Cadena_Vacia;
SET MensajeTMP 			:= Cadena_Vacia;
SET Tam_Mensaje			:= Entero_Cero;
SET Var_ColorBG			:= '#1E4663';
SET Fecha_Vacia			:= '1900-01-01';
SET Var_ProcesoPld		:= 'PLD';

	/** Tabla temporal para el envio de correo **/
	DROP TABLE IF EXISTS TMPENVIOCORREOPLD;
	CREATE TEMPORARY TABLE TMPENVIOCORREOPLD(
		RegistroID bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
		Mensaje TEXT
	);
	SET Var_VersionSAFI		:= (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'VersionSAFI');
	SET Var_VersionSAFI		:= CONCAT('SAFI v', IFNULL(Var_VersionSAFI, Entero_Cero));

	-- Se obtienen los parametros de la cuenta de correo que realiza el envio del mismo
	SELECT PAR.Remitente, PAR.ServidorCorreo, PAR.Puerto, PAR.UsuarioCorreo,	PAR.Contrasenia,
			Correo,					USU.NombreCompleto
	  INTO Var_Remitente,Var_ServidorCorreo,  Var_Puerto, Var_UsuarioCorreo,	Var_Contrasenia,
			Var_DestinatarioPLD,	Var_NombreCompleto
		FROM USUARIOS USU,
				PARAMETROSSIS PAR
			WHERE PAR.OficialCumID= USU.UsuarioID;


	SELECT CAST(ValorParametro AS UNSIGNED)
		INTO Var_RemitenteID
		FROM PARAMGENERALES
		WHERE LlaveParametro =  'RemitentePld';

	SET Var_RemitenteID := IFNULL(Var_RemitenteID, Entero_Cero);

	SET Con_Mensaje :=CONCAT(
		'<table cellspacing="0" cellpadding="0" border="0" bgcolor="#ffffff" style="width:100%;max-width:600px;margin:0 auto"> ',
		'<tbody> ',
			'<tr> ',
				'<td colspan="3" align="left" style="line-height:0;box-sizing:border-box;padding:24px 40px 16px 40px; color:white; font-family:Arial" bgcolor="',Var_ColorBG,'" width="600px" height="74px"><img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAHgAAABLCAQAAAARg4taAAAABGdBTUEAALGPC/xhBQAAAAFzUkdCAK7OHOkAAAAgY0hSTQAAeiYAAICEAAD6AAAAgOgAAHUwAADqYAAAOpgAABdwnLpRPAAAAAJiS0dEAP+Hj8y/AAAACXBIWXMAAABIAAAASABGyWs+AAAIgUlEQVR42u2ba3BV1RXHfzsPngnhkUqQUCJShFZhCA4OTOXVAn5okFGLI0URrZUBHbW2OoBM0TLSGWtnFGitbZWXlpcI1qFUDDPUpDxqKQXbKiCmYgLyCI9CIc9/P+Tk3nNy9zn3JueSCzP5nw/3nLPWWXv/z1p7n7UfF9rQhjZczTDxFNSJ4QylP3l0IdNXLQ1DneX+j8yHqaaYMJSh7+pdXVQYfDXVLBIli6boUCiqknRAqSYSgwwr3a68zuQkWF8Rt8VcCVC+/hXat5J0Wj1SzSURut2SRFeamWouidA12pQkur/X1RDPuidJdN9R+1RzscPjBbXjEwpC26zn58wzta1DQJBFToTHSXNJOWRbFGvMl7EPT02Cb9/X8NYhqoGar2066Sn9m6BfWetV3PCc97N0f9xyqjhKlVVyiTJ28bb5uFXoFrKI8ZY8sRzobX2kPNZIF1UH+m6bxso/uWw1yGi+aqw1rFMH0N+sskWxhm4LpLte6amm6tB91beOxwXoqFX2SMPzaS5bQwPKqeZRU8eVgKd4yFdWblAm19hlsYT7BxTzoTmaaqYAGsRzAeJyoJeHUxQVsYR7BZi6IugCC2gXh3DvABneXjorwFR9qpkCKI87fEQneYmtHAT2MciqURFLOGgsN0TGpH6sN8k+uuNjxjU2OXOBwA+jO6TPBOgN4IFUswVG+9y/P/Eexv3GygI1X9VYNnCYaovsIpWca4UIuMl69xC7EjfhylV0H8tDVOY0H1HCJnYZQIXM9wm/YJzjM3ZQbC6B2vEsN3qk47ENSU6xI67dn5rdMfeUp9ok5NJ/V5EATdSFFtuo1AJ1BHXXv5NQI0k++b3eSZL5VeoIKlJdCBv7VQAaEifdTRT2j5UKk+JjSdqm9qAXQ9n4VLmgpUmoTY38mpcWJomwtBSUG3KSd71QQRKc8IVv21aaliWJcL1uBm0IaWUE6E+h6+LqxZvknaaeGczxGfE2D4angD+EtDIL2BC6LuVx5PqaloUMRkm6qCz1CWnjtDLUP3RNFrv94Ec6h9sYxWCuowft469BWTHBbNWfY9L5+pjMPINcuvjYGMJ+SsgCCqw69XzkusrlWovOHPOzZtRaRunKiDm6alzcz9gPEy4jTc/52JgS0fnAKj/isbPAqnNvVCMtfmWMTJ2pjTnOmG3czhuBj+YnStjUs8ZHFB209rHKPYR9dCqipy1J/1yvQgv5XoBC59hbakeWtdQcHxvOoFXpPuN17yfHTtjVaYUiDBygOnBIHiWawWTuYgT5iUSV+0Hnt6dPOV4P22MqiYTTCZra+2+k1mN4hRtaVMJ557ePj9xFWMZK+Fy0HuEJ9w8kfMypyIP8mpbOeR53fv36A3dId7WuOZS7PzHNC69YfCdQ+imAJoagG/VgAh6OH9AhCSufHwcq7AN15rch6DaPcNwuK0RIK5MifsFXAlQqOAw8ZH3vp1jL554E5BFrdWsj86V279XgXiJrOWFBIRO4iWt8vNOFGwJnOQE2GwEPWiRnKDSfNynRvnx+1NQEkqnwLA8kENIWwjJMYZ7P/FFz8AaoT5NJmgZsjKGb5vOVjQZsy9OOYMLKYwXjQ5OFf7AdsE+tHIu504MOVk3nxSgjOWlHTKelgexOCl2Yb4Tf8s0ENaXnt17Q6MFePk2rmWlHEw+rN1sTz38D8ZYzEs61Sgs5qFL+57rjt8zTGPqJpB12wjWc8CGsNN5MEt2D/MD52Pst0eRzd0KWjkT07XCHdC6dLBrHvJsv3CE9nVFJoVvGRFPZpMItRfi0o8J7GSGsNOYlhW4JI81nkav3CLce0YyQTqTLcnv4Vq4PTfY0TzDGvc5jDvC7EPYucMo5s3vvkqd9JtBludvwhFBUxT6W85o5GyOZxXlm07K9IV9E1qv80g53H5GQh6OEu3HQ+kAd/juu6jjPlxxmLyXmP3YVU8MTeoFJ3EwBPejYrOw9uh5Uba2ddy92ulXnk2aU14Y2tKENbWhDiqCXVeocJVqtSR7Zcm1VZFZYw1Sq5yNX16tUXwd1UamcXVTK1DKtVkfQNJWqkyNd27hbU2narjud8+6aqy2Rsvtdbp7RxOMbXMsqANIZxiZNNyucKt3IvdRRxFuOZg4jGaE/mg8A6MxIsoEMRjYsvCiN5XyL0eYi0JuRpDtSKOFlAAwjWAugARSTycZIinjhchOOQMXaFjlHf9X7kavF2qf3tDlyPU7STv2zwecaLOkWUHdJs0Boic6o0NF9WlK2I/2LziofQOmq1mwQ2qn96t5qJPGZpjVwonHKRZ2Zxjo2MEHuXHUuBTxteW2wgBkUmT0Ws0s4zmLP4GkYt7AgMpRsdcId1Fd91Vf9dAejeNe5ezfZLGcdtZ798mU8y1wNiLH3KD9hhhPsTVHFLG73/AFsOFDSmnRdULFnRfWQegII7WoIZq3RYaWBE9L9lKm9KpbxhPQ2VeuM1ka96AnpO0ErdUTZkZCeKzkNY7X2aI/26MXLzdPt4VLyyCOPXtxKFRsFMJThbNdgDWYH1zEuqmxqmMkY7vNYG8PDTOcuvu9b3pN0ZGHk6jyNy6FrWMpScrjsvXQE7k4L9Lik7qBXPH5fDY0eBtASndBYl4dfANAvdV4DHTtNPAx6QLUa7nh4tKRvu0rdqbcvN0+/0Wk36qlSNlNZRKZzPM/kJv8mnEcVz7iuG6Z2nqSMN33/qPU6JTQGbgmHmNO6fxxxT9P21FTnJQzgcbaYC3qYzvymcdZPrzGHabwUfcCc1WOsb2rSXNQ97GYR1h0eRprJ3oYZEFOnGWxhh1Y5i6K5rbjzXhtV6RyndFBL1E2oWJ49Utqs7dlolCpV4NxB61SpYaBuqlRkHUmzdUqjQI+pUlmOtCgifUaVctq5BmmlyiJlr2w1wm1oQxuuSvwfz1oVFziBMMAAAABidEVYdGNvbW1lbnQAYm9yZGVyIGJzOjAgYmM6IzAwMDAwMCBwczowIHBjOiNmZmZmZmYgZXM6MCBlYzojMDAwMDAwIGNrOmZlZWU2YzcxNWQyNmZkOWYzOGIwY2E0Mjc4YzA1MDI2iprg+wAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAxOS0wOC0yM1QwMDozODo0NSswMDowMHwAIxcAAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTktMDgtMjNUMDA6Mzg6NDUrMDA6MDANXZurAAAAAElFTkSuQmCC"></td> ',
			'</tr> ',
			'<tr> ',
				'<td colspan="3" align="left" style="font-family:Arial;color:#566270;font-size:15px;line-height:19px;padding:30px 40px">Estimado(a) <b>',Var_NombreCompleto,'</b>.<br><br> ',
				'Existen nuevas Operaciones Inusuales:<br><br> ',
				'<table style="color:#00000"> ',
					'<thead style="background-color:',Var_ColorBG,'; color:#ffffff;font-family:Arial; text-align:center;"> ',
						'<tr> ',
							'<td class="label" nowrap="nowrap" style="font-size: 12px; padding-right: 8px; padding-left: 8px;"><label>Folio</label></td> ',
							'<td class="label" nowrap="nowrap" style="font-size: 12px; padding-right: 8px; padding-left: 8px;"><label>N&uacute;m. y Nombre<br>de la Pers. Involucrada</label></td> ',
							'<td class="label" nowrap="nowrap" style="font-size: 12px; padding-right: 8px; padding-left: 8px;"><label>Fecha Detecci&oacute;n</label></td> ',
							'<td class="label" nowrap="nowrap" style="font-size: 12px; padding-right: 8px; padding-left: 8px;"><label>Fecha Operaci&oacute;n</label></td> ',
							'<td class="label" nowrap="nowrap" style="font-size: 12px; padding-right: 8px; padding-left: 8px;"><label>Descripci&oacute;n<br>de la Operaci&oacute;n</label></td> ',
						'</tr> ',
					'</thead> ',
					'<tbody style="vertical-align: text-top; font-size: 11px; color:#566270;"> ');
	SET Var_PieMensaje := CONCAT(
						'</tbody>',
						'</table>',
						'<br>',
						'Por favor, dir&iacute;jase a la pantalla ubicada en SAFI para darle(s) seguimiento oportuno:',
						'<br><b>Prevencion LD > Procesos >  Segto. Operaciones Inusuales</b>',
						'<br>',
						'<br>',
						'Gracias.',
					'</td> ',
				'</tr> ',
				'<tr> ',
					'<td colspan="3" align="right" style="height:10px;background-color:',Var_ColorBG,';width:600px;padding:10px 5px 5px 5px;box-sizing:border-box;color: #ffffff;font-size: 10px;font-family:Arial;"> ',
						'<label>',Var_VersionSAFI,'</label> ',
					'</td> ',
				'</tr> ',
			'</tbody> ',
		'</table> ');
	SET LimiteMsg := LimiteMsg - (LENGTH(Con_Mensaje)+LENGTH(Var_PieMensaje));
	OPEN  CURSORENVIOMENSAJE;
		SELECT FOUND_ROWS() INTO Var_NumRows;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			LOOP
				FETCH CURSORENVIOMENSAJE  INTO
					Var_OperacionID,   Var_Persona,    Var_FechaOperacion,    Var_DesOperacion,	Var_ClavePersonaInv,
					Var_FechaDeteccion;

					SET MensajeTMP	:= CONCAT(
						'<tr style="border-bottom: 1px solid ',Var_ColorBG,';"> ',
							'<td width="200px" style="text-align: center;">',Var_OperacionID,'</td> ',
							'<td width="200px">',Var_ClavePersonaInv,' - ',Var_Persona,'</td> ',
							'<td width="200px" style="text-align: center;">',Var_FechaDeteccion,'</td> ',
							'<td width="200px" style="text-align: center;">',Var_FechaOperacion,'</td> ',
							'<td width="200px" style="text-align: left;">',Var_DesOperacion,'</td> ',
						'</tr> ');

					SET Tam_Mensaje := LENGTH(MensajeTMP)+LENGTH(Con_MensajeDes); -- Se suma el tamanio de los mensajes

					IF (Tam_Mensaje<LimiteMsg) THEN -- Si el tamanio del mensaje no supera el tamanio limite entonces se siguen concatenando
						SET Con_MensajeDes	:= CONCAT(Con_MensajeDes, MensajeTMP);
					  ELSE -- si no se inserta en la tabla temporal
						INSERT INTO TMPENVIOCORREOPLD(Mensaje) VALUES (Con_MensajeDes);
						SET Con_MensajeDes := CONCAT(MensajeTMP);
					END IF;

					# SI ALCANZÓ EL TOTAL DE REGISTROS, SE REGISTRA EN LA TABLA.
					IF(Var_NumRows=Var_Contador)THEN
						INSERT INTO TMPENVIOCORREOPLD(Mensaje) VALUES (Con_MensajeDes);
					END IF;
					SET Var_Contador := Var_Contador + 1;
			END LOOP;
		END;
	CLOSE CURSORENVIOMENSAJE;


	OPEN  CURSORENVIOCORREO;
	BEGIN
		DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			LOOP
				FETCH CURSORENVIOCORREO  INTO Var_MensajeTemporal;

				-- Se concluye el armado del cuerpo del mensaje de correo
				SET Con_MensajeEnviar := CONCAT(Con_Mensaje,Var_MensajeTemporal,Var_PieMensaje);

				CALL TARENVIOCORREOALT(
					Var_RemitenteID,	Var_DestinatarioPLD,	Con_Asunto, 		Con_MensajeEnviar,			Entero_Cero,
					Par_Fecha,			Fecha_Vacia,			Var_ProcesoPld,		Cadena_Vacia,				SalidaNO,
					Par_NumErr, 		Par_ErrMen, 			Par_EmpresaID,		Aud_Usuario ,				Aud_FechaActual,
					Aud_DireccionIP, 	Aud_ProgramaID, 		Aud_Sucursal, 		Aud_NumTransaccion);

			END LOOP;
		END;
	CLOSE CURSORENVIOCORREO;

	DROP TABLE IF EXISTS TMPENVIOCORREOPLD;

	SET Par_NumErr := Entero_Cero;
	SET Par_ErrMen := 'Envio de Alertas PLD Exitoso.';

	IF(IFNULL(Par_Salida,SalidaNO)=SalidaSI)THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'numero' AS Control,
				Entero_Cero AS Consecutivo;
	END IF;

END TerminaStore$$
