-- EMPLEADOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `EMPLEADOSCON`;
DELIMITER $$

CREATE PROCEDURE `EMPLEADOSCON`(
# ==========================================================
#			SP PARA LA CONSULTA DE EMPLEADOS
# ==========================================================
	Par_EmpleadoID			INT(11),		-- Id del empleado
	Par_RFC					CHAR(13),		-- RFP
	Par_NumCon			TINYINT UNSIGNED,	-- Parametro para el numero de consulta
  
    Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);	-- Cadena vacia
	DECLARE	Fecha_Vacia		DATE;		-- Fecha vacia
	DECLARE	Entero_Cero		INT(11);	-- Entero cero
	DECLARE	Con_Principal	INT(11);	-- Consulta principal
	DECLARE	Con_Foranea		INT(11);	-- Consulta Foranea

	DECLARE	Con_RFC			INT(11);	-- Consulta RFC
	DECLARE Con_SinEstatus	INT(11);	-- Consulta sin estatus
    DECLARE Est_Activo		CHAR(1);	-- Estatus activo
    DECLARE Con_Organigrama	INT(11);	-- Conulta 5 datos del empleado en el organigrama

	-- asignacion de constantess
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Con_Principal		:= 1;
	SET	Con_Foranea			:= 2;

	SET	Con_RFC				:= 3;
    SET Con_SinEstatus		:= 4;
    SET Est_Activo			:= 'A';
    SET Con_Organigrama		:= 6;

	-- 1.- Consulta principal
	IF(Par_NumCon = Con_Principal) THEN
		SELECT	EmpleadoID,		ClavePuestoID, 	ApellidoPat,		ApellidoMat,		PrimerNombre,
				SegundoNombre,	FechaNac,	  	RFC,				NombreCompleto,		SucursalID,
                Estatus,		Nacionalidad,	LugarNacimiento,	EstadoID,			Sexo,
                CURP
		FROM EMPLEADOS
		WHERE  EmpleadoID = Par_EmpleadoID
		AND	   Estatus = Est_Activo;
	END IF;

	-- 4.- CONSULTAR EMPLEADO SIN IMPORTAR ESTATUS
	IF(Par_NumCon = Con_SinEstatus) THEN
		SELECT	EmpleadoID,		ClavePuestoID, 	ApellidoPat,		ApellidoMat,		PrimerNombre,
				SegundoNombre,	FechaNac,	  	RFC,				NombreCompleto,		SucursalID,
				Estatus,		Nacionalidad,	LugarNacimiento,	EstadoID,			Sexo,
                CURP
		FROM EMPLEADOS
		WHERE  EmpleadoID = Par_EmpleadoID;
	END IF;

	-- 2.- Consulta descripcion del puesto
	IF(Par_NumCon = Con_Foranea) THEN
		SELECT P.Descripcion
		FROM EMPLEADOS E
		INNER JOIN PUESTOS P ON E.ClavePuestoID= P.ClavePuestoID
		WHERE E.EmpleadoID=Par_EmpleadoID;
	END IF;

	-- 3.- Consulta RFC
	IF(Par_NumCon = Con_RFC) THEN
		SELECT RFC
		FROM EMPLEADOS
		WHERE RFC=Par_RFC;
	END IF;
    
    -- 5.- Consulta puesto, categoria del puesto, y datos del organigrama del empleado
	IF(Par_NumCon = Con_Organigrama) THEN
		SELECT 	E.NombreCompleto,	P.Descripcion AS Puesto,	C.NivelJerarquia AS CategoriaID,	O.CtaContable,	O.CentroCostoID, 
				CONCAT(J.EmpleadoID,' - ',J.NombreCompleto) AS JefeInmediato,	E.Estatus
		FROM EMPLEADOS E
			INNER JOIN PUESTOS P 
				ON E.ClavePuestoID = P.ClavePuestoID
			LEFT JOIN ORGANIGRAMA O
				ON E.EmpleadoID = O.PuestoHijoID
			LEFT JOIN EMPLEADOS J
				ON O.PuestoPadreID = J.EmpleadoID
			LEFT JOIN CATEGORIAPTO C
				ON P.CategoriaID = C.CategoriaID
		WHERE E.EmpleadoID = Par_EmpleadoID;
	END IF;

END TerminaStore$$