-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- VALPRODUCPERFIL
DELIMITER ;
DROP PROCEDURE IF EXISTS `VALPRODUCPERFIL`;DELIMITER $$

CREATE PROCEDURE `VALPRODUCPERFIL`(
# ================================================================
# --- SP PARA VALIDAR EL TIPO DE CEDE CON EL PERFIL DEL CLIENTE---
# ================================================================
	Par_ClienteID		INT(11),			-- ClienteID a Validar.
	Par_IdProducto		INT(11),			-- Id Producto(Cedes).
	Par_TipoValidacion	INT(1),				-- Tipo de Validacion 3.-Cedes

	Par_Salida    		CHAR(1), 			-- Indica Mensaje de Salida(S= Si, N=No).
	INOUT Par_NumErr 	INT(11),			-- INOUT Numero de Error.
	INOUT Par_ErrMen  	VARCHAR(400),		-- INOUT Mensaje de Error.

	Par_EmpresaID		INT(11),			-- Parametro de Auditoria Par_EmpresaID.
	Aud_Usuario			INT(11),			-- Parametro de Auditoria Aud_Usuario.
	Aud_FechaActual		DATETIME,			-- Parametro de Auditoria Aud_FechaActual.
	Aud_DireccionIP		VARCHAR(15),		-- Parametro de Auditoria Aud_DireccionIP.
	Aud_ProgramaID		VARCHAR(50),		-- Parametro de Auditoria Aud_ProgramaID.
	Aud_Sucursal		INT(11),			-- Parametro de Auditoria Aud_Sucursal.
	Aud_NumTransaccion  BIGINT(20)			-- Parametro de Auditoria Aud_NumTransaccion.
)
TerminaStore : BEGIN
	-- Declaracion de Constantes.
	DECLARE ParfilCedes				INT(1);
	DECLARE SalidaSI				CHAR(1);
	DECLARE	EnteroCero				INT(1);
	DECLARE CadenaVacia				CHAR(1);
	DECLARE DesProducto				VARCHAR(100);
	DECLARE PersonaMoral			VARCHAR(1);

	-- Declaracion de Variables.
	DECLARE Var_Sexo				CHAR(1);
	DECLARE Var_EdoCivil			VARCHAR(3);
	DECLARE Var_Edad				INT(3);
	DECLARE Var_ActividadBMX		VARCHAR(15);
	DECLARE Var_FechaSis			DATE;
	DECLARE Var_ProGenero			VARCHAR(4);			-- Genero Almacenado en Datos del Perfil Inversiones.
	DECLARE Var_ProEstadosCivil		VARCHAR(100);		-- Estados Civil que Permite la Inversion.
	DECLARE Var_ProMinEdad			INT(3);				-- Minimo de Edad que Permite la Inversion.
	DECLARE Var_ProMaxEdad			INT(3);				-- Maximo de Edad que Permite la Inversion.
	DECLARE Var_ProActividadBMX		VARCHAR(750);		-- Actividad BMX que permite la Inversion.
	DECLARE Var_TipoPersonaCli		VARCHAR(1);

	-- Asignacion de Contantes.
	SET ParfilCedes			:=	3;						-- Validacion del Perfil de Cedes.
	SET SalidaSI			:= 	'S';					-- Constante Salida SI.
	SET EnteroCero			:=	0;						-- Constante Entero Cero.
	SET CadenaVacia			:=	'';						-- Contante Cadena Vacia.
	SET DesProducto			:= 	'';						-- Descripcion del Produto SAFI para el Mensaje de Validacion(Cuenta,Inversion,Cede).
	SET PersonaMoral		:=	'M';					-- Persona moral

	-- Asignacion de Variables.
	SET Var_FechaSis	:= (SELECT FechaSistema	FROM PARAMETROSSIS);

	ManejoErrores:BEGIN


		IF (Par_TipoValidacion = ParfilCedes) THEN
			SET DesProducto	:=	'CEDE';

			SELECT 		cede.Genero,			cede.EstadoCivil,		cede.MinimoEdad,		cede.MaximoEdad,
						cede.ActividadEcon
				INTO	Var_ProGenero,			Var_ProEstadosCivil,	Var_ProMinEdad,			Var_ProMaxEdad,
						Var_ProActividadBMX
				FROM TIPOSCEDES cede
				WHERE cede.TipoCedeID = Par_IdProducto;

		END IF;

		SELECT		cte.Sexo,	cte.EstadoCivil,	cte.ActividadBancoMX,	(YEAR (Var_FechaSis)- YEAR (cte.FechaNacimiento)) - (RIGHT(Var_FechaSis,5)<RIGHT(cte.FechaNacimiento,5)) AS Edad,
					TipoPersona
			INTO 	Var_Sexo,	Var_EdoCivil,		Var_ActividadBMX,		Var_Edad,
					Var_TipoPersonaCli
			FROM 	CLIENTES cte
			WHERE 	cte.ClienteID	= Par_ClienteID;

		IF(LOCATE(Var_Sexo,Var_ProGenero) = EnteroCero) THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= CONCAT('El Tipo de ',DesProducto,' no Permite el Genero.');
			LEAVE ManejoErrores;
		END IF;

		IF(LOCATE(Var_EdoCivil,Var_ProEstadosCivil)= EnteroCero) THEN
			SET Par_NumErr	:= 002;
			SET Par_ErrMen	:= CONCAT('El Tipo de ',DesProducto,' no Permite el Estado Civil.');
			LEAVE ManejoErrores;
		END IF;

		IF(Var_Edad < Var_ProMinEdad) THEN
			IF (Var_TipoPersonaCli <> PersonaMoral) THEN
				SET Par_NumErr	:= 003;
				SET Par_ErrMen	:= CONCAT('No Se Cumple con el Minimo de Edad Permitido por el Tipo de ',DesProducto,'.');
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Var_Edad >= Var_ProMaxEdad) THEN
			IF (Var_TipoPersonaCli <> PersonaMoral) THEN
				SET Par_NumErr	:= 004;
				SET Par_ErrMen	:= CONCAT('Se Excede el Maximo de Edad Permitido por el Tipo de ',DesProducto,'.');
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Var_ProActividadBMX,CadenaVacia) != CadenaVacia) THEN
			IF(LOCATE(Var_ActividadBMX,Var_ProActividadBMX) = EnteroCero) THEN
				SET Par_NumErr	:= 011;
				SET Par_ErrMen	:= CONCAT('La Actividad BMX no es Permitida por el Tipo de ',DesProducto,'.');
				LEAVE ManejoErrores;
			END IF;
		END IF;

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr	AS NumErr,
				Par_ErrMen 	AS ErrMen;
	END IF;

END TerminaStore$$