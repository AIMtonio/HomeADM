-- SP HUELLADIGITALTARLIS

DELIMITER ;
DROP PROCEDURE IF EXISTS `HUELLADIGITALTARLIS`;

DELIMITER $$
CREATE PROCEDURE `HUELLADIGITALTARLIS`(
# ======================================================================
# ------- STORED PARA LISTAS DE HUELLA DIGITAL ---------
# ======================================================================
	Par_PIDTarea			VARCHAR(50),		-- Parámetro numero referente a la tarea.
	Par_NumLis				TINYINT UNSIGNED,	-- Parámetro numero de lista.
	Par_NumeroPagina		INT(11),			-- Parámetro numero de pagina.
	Par_RegPorPagina		INT(11),			-- Parámetro numero de Registros por pagina.

	Aud_EmpresaID         	INT(11),			-- Parámetro de auditoría ID de la empresa.
	Aud_Usuario         	INT(11),			-- Parámetro de auditoría ID del usuario.
	Aud_FechaActual     	DATETIME,			-- Parámetro de auditoría fecha actual.
	Aud_DireccionIP     	VARCHAR(15),		-- Parámetro de auditoría direccion IP.
	Aud_ProgramaID      	VARCHAR(50),		-- Parámetro de auditoría programa.
	Aud_Sucursal        	INT(11),			-- Parámetro de auditoría ID de la sucursal.
	Aud_NumTransaccion  	BIGINT(20)			-- Parámetro de auditoría numero de transaccion.
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_MinHuellaID			INT(11);		-- Variable para alamacenar el minimo AutHuellaDigitalID.
	DECLARE Var_MaxHuellaID			INT(11);		-- Variable para alamacenar el maximo AutHuellaDigitalID.

	-- DECLARACION DE CONSTANTES
	DECLARE	Entero_Cero				INT(11);		-- Constante número cero (0).
	DECLARE Cadena_Vacia			CHAR(1);		-- Constante cadena vacia ''.
	DECLARE Cons_Cliente			CHAR(1);		-- Constante Cliente 'C'.
	DECLARE Cons_Usuario			CHAR(1);		-- Constante Usuario 'U'.
	DECLARE Cons_Firmante			CHAR(1);		-- Constante Firmante 'F'.

	DECLARE Cons_UsuarioServicios	CHAR(1);		-- Constante Usuario de Servicios 'S'.
	DECLARE Lis_HuellaTarea			INT(11);		-- lista de huellas registradas que se van a comparar.
	DECLARE Lis_HuellaPagina		INT(11);		-- Lista de huellas por pagina.
	DECLARE Est_EnProceso			CHAR(1);		-- Constante estatus en proceso 'P'.
	DECLARE Huella_Repetida			CHAR(1);		-- Constante estatus repetida 'R'.

	-- ASIGNACION DE CONSTANTES
	SET	Entero_Cero					:= 0;
	SET Cadena_Vacia				:= '';
	SET Cons_Cliente				:= 'C';
	SET Cons_Usuario				:= 'U';
	SET Cons_Firmante				:= 'F';

	SET Cons_UsuarioServicios		:= 'S';
	SET Lis_HuellaTarea				:= 1;
	SET Lis_HuellaPagina			:= 2;
	SET Est_EnProceso				:= 'P';
	SET Huella_Repetida				:= 'R';

	-- 1.- Lista de las huellas que se van a comparar.
    IF (Par_NumLis = Lis_HuellaTarea) THEN

        SELECT	hue.AutHuellaDigitalID,	hue.TipoPersona,	hue.PersonaID,	hue.PIDTarea,		hue.HuellaUno,
				hue.FmdHuellaUno,		hue.DedoHuellaUno,	hue.HuellaDos,	hue.FmdHuellaDos,	hue.DedoHuellaDos,
				hue.Estatus,			IFNULL(Cli.RFCOficial, Cadena_Vacia) AS RFC
		FROM HUELLADIGITAL hue
		INNER JOIN CLIENTES Cli ON hue.PersonaID = Cli.ClienteID
		WHERE hue.Estatus = Est_EnProceso
		AND hue.PIDTarea = Par_PIDTarea
		AND hue.PersonaID = Cli.ClienteID
		AND hue.TipoPersona = Cons_Cliente
		UNION
			SELECT	hue.AutHuellaDigitalID,	hue.TipoPersona,	hue.PersonaID,	hue.PIDTarea,		hue.HuellaUno,
    				hue.FmdHuellaUno,		hue.DedoHuellaUno,	hue.HuellaDos,	hue.FmdHuellaDos,	hue.DedoHuellaDos,
					hue.Estatus,			IFNULL(U.RFC, Cadena_Vacia) AS RFC
			FROM HUELLADIGITAL hue
			INNER JOIN USUARIOS U ON hue.PersonaID = U.UsuarioID
			WHERE hue.Estatus = Est_EnProceso
	    	AND hue.PIDTarea = Par_PIDTarea
	    	AND hue.PersonaID = U.UsuarioID
	        AND hue.TipoPersona = Cons_Usuario
		UNION
			SELECT	hue.AutHuellaDigitalID,	hue.TipoPersona,	hue.PersonaID,		hue.PIDTarea,		hue.HuellaUno,
					hue.FmdHuellaUno,		hue.DedoHuellaUno,	hue.HuellaDos,		hue.FmdHuellaDos,	hue.DedoHuellaDos,
					hue.Estatus,			IFNULL(Per.RFC, Cadena_Vacia) AS RFC
	        FROM HUELLADIGITAL hue
	        INNER JOIN CUENTASFIRMA Fir ON hue.PersonaID = Fir.CuentaFirmaID AND hue.TipoPersona = Cons_Firmante
            INNER JOIN CUENTASPERSONA Per ON Fir.CuentaAhoID = Per.CuentaAhoID AND Fir.PersonaID = Per.PersonaID
			WHERE hue.Estatus = Est_EnProceso
	    	AND hue.PIDTarea = Par_PIDTarea
	    	AND hue.PersonaID = Per.PersonaID
	        AND hue.TipoPersona = Cons_Firmante
		UNION
			SELECT	hue.AutHuellaDigitalID,	hue.TipoPersona,	hue.PersonaID,	hue.PIDTarea,		hue.HuellaUno,
    				hue.FmdHuellaUno,		hue.DedoHuellaUno,	hue.HuellaDos,	hue.FmdHuellaDos,	hue.DedoHuellaDos,
					hue.Estatus,			IFNULL(US.RFCOficial, Cadena_Vacia) AS RFC
			FROM HUELLADIGITAL hue
			INNER JOIN USUARIOSERVICIO US ON US.UsuarioServicioID = hue.PersonaID
			WHERE hue.Estatus = Est_EnProceso
	    	AND hue.PIDTarea = Par_PIDTarea
	    	AND hue.PersonaID = US.UsuarioServicioID
	        AND hue.TipoPersona = Cons_UsuarioServicios;
    END IF;

	-- 2.- Lista de huella por pagina contra las que se compararan.
	IF (Par_NumLis = Lis_HuellaPagina) THEN

		SET Var_MaxHuellaID := Par_NumeroPagina * Par_RegPorPagina;
		SET Var_MinHuellaID := (Var_MaxHuellaID - Par_RegPorPagina) + 1;

		SELECT	hue.AutHuellaDigitalID,	hue.TipoPersona,	hue.PersonaID,		hue.HuellaUno,		hue.FmdHuellaUno,
				hue.DedoHuellaUno,		hue.HuellaDos,		hue.FmdHuellaDos,	hue.DedoHuellaDos,	IFNULL(Cli.RFCOficial, Cadena_Vacia) AS RFC
		FROM HUELLADIGITAL hue
		INNER JOIN CLIENTES Cli ON hue.PersonaID = Cli.ClienteID
		WHERE hue.AutHuellaDigitalID BETWEEN Var_MinHuellaID AND Var_MaxHuellaID
		AND hue.PersonaID = Cli.ClienteID
		AND hue.TipoPersona = Cons_Cliente
        AND hue.Estatus <> Huella_Repetida
		UNION
			SELECT	hue.AutHuellaDigitalID,	hue.TipoPersona,	hue.PersonaID,		hue.HuellaUno,		hue.FmdHuellaUno,
					hue.DedoHuellaUno,		hue.HuellaDos,		hue.FmdHuellaDos,	hue.DedoHuellaDos,	IFNULL(U.RFC, Cadena_Vacia) AS RFC
			FROM HUELLADIGITAL hue
			INNER JOIN USUARIOS U ON hue.PersonaID = U.UsuarioID
			WHERE hue.AutHuellaDigitalID BETWEEN Var_MinHuellaID AND Var_MaxHuellaID
			AND hue.PersonaID = U.UsuarioID
	        AND hue.TipoPersona = Cons_Usuario
            AND hue.Estatus <> Huella_Repetida
		UNION
			SELECT	hue.AutHuellaDigitalID,	hue.TipoPersona,	hue.PersonaID,		hue.HuellaUno,		hue.FmdHuellaUno,
					hue.DedoHuellaUno,		hue.HuellaDos,		hue.FmdHuellaDos,	hue.DedoHuellaDos,	IFNULL(Per.RFC, Cadena_Vacia) AS RFC
	        FROM HUELLADIGITAL hue
	        INNER JOIN CUENTASFIRMA Fir ON hue.PersonaID = Fir.CuentaFirmaID AND hue.TipoPersona = Cons_Firmante
            INNER JOIN CUENTASPERSONA Per ON Fir.CuentaAhoID = Per.CuentaAhoID AND Fir.PersonaID = Per.PersonaID
			WHERE hue.AutHuellaDigitalID BETWEEN Var_MinHuellaID AND Var_MaxHuellaID
			AND hue.PersonaID = Per.PersonaID
	        AND hue.TipoPersona = Cons_Firmante
            AND hue.Estatus <> Huella_Repetida
		UNION
			SELECT	hue.AutHuellaDigitalID,	hue.TipoPersona,	hue.PersonaID,		hue.HuellaUno,		hue.FmdHuellaUno,
					hue.DedoHuellaUno,		hue.HuellaDos,		hue.FmdHuellaDos,	hue.DedoHuellaDos,	IFNULL(US.RFCOficial, Cadena_Vacia) AS RFC
			FROM HUELLADIGITAL hue
			INNER JOIN USUARIOSERVICIO US ON US.UsuarioServicioID = hue.PersonaID
			WHERE hue.AutHuellaDigitalID BETWEEN Var_MinHuellaID AND Var_MaxHuellaID
			AND hue.PersonaID = US.UsuarioServicioID
	        AND hue.TipoPersona = Cons_UsuarioServicios
            AND hue.Estatus <> Huella_Repetida;
	END IF;

END TerminaStore$$