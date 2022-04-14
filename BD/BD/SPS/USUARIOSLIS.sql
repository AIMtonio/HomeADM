-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- USUARIOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `USUARIOSLIS`;
DELIMITER $$


CREATE PROCEDURE `USUARIOSLIS`(
	Par_NombUsuario 	VARCHAR(50),		-- ID del usuario
	Par_Sucursal		INT(11) ,			-- Numero de sucursal
	Par_NumLis			TINYINT UNSIGNED,	-- Numero de consulta
	Par_EmpresaID		INT(11),			-- Parametro de auditoria ID de la empresa

	Aud_Usuario			INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual		DATETIME,			-- Parametro de auditoria Fecha actual
	Aud_DireccionIP		VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID		VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal		INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion	BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
	)

TerminaStore: BEGIN

-- DECLARACION DE CONSTANTES
DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT(11);
DECLARE	Lis_Principal 		INT(11);
DECLARE	Lis_PorSuc 			INT(11);

DECLARE	EsGestorSI			CHAR(1);
DECLARE	EsSupervisorSI	    CHAR(1);
DECLARE Lis_UsuarioGestor 	INT(1);
DECLARE TipoSupervisor   	INT(11);
DECLARE EstatusActivo   	CHAR(1);
DECLARE TipoUsuAnalista     CHAR(1);
DECLARE TipoAsesor		    VARCHAR(20);

DECLARE EstatusVigente  	CHAR(1);
DECLARE Lis_Supervisor  	INT(11);
DECLARE Lis_Gestores    	INT(11);
DECLARE Lis_UserFR		 	INT(11);
DECLARE Lis_GestProm    	INT(11);

DECLARE Lis_UsuSupervisor  	INT(11);
DECLARE Lis_UsuariosActivos INT(11);
DECLARE Lis_UsuAsamGral     INT(11);
DECLARE EstatusBloqueado	CHAR(1);
DECLARE Lis_UsuActBloq		INT(11);
DECLARE Lis_AnalistasSol	INT(11);
DECLARE Lis_RolAnalista     INT(11);
DECLARE Lis_RolCoordinador	INT(11);
DECLARE Lis_RolAsesor		INT(11);
DECLARE Lis_ConCorreo		INT(11);

-- DECLARACION DE VARIABLES
DECLARE Var_UsuID           		INT(11);
DECLARE Var_NombreAnalistaV 		VARCHAR(20);
DECLARE Var_LlaveRolCoordinador		VARCHAR(100);		-- Llave para consultar el valor del rol coordinador
DECLARE Var_RolCoordinador			INT(11);			-- Variable para almacenar el rol coordinador

-- ASIGNACIOND DE CONSTANTES
SET EsGestorSI	 		:= 'S';
SET EsSupervisorSI	 	:= 'S';
SET	Cadena_Vacia		:= '';
SET	Fecha_Vacia			:= '1900-01-01';
SET	Entero_Cero			:= 0;

SET	Lis_Principal		:= 1;
SET	Lis_PorSuc	   		:= 3;
SET Lis_UsuarioGestor 	:= 4;
SET TipoSupervisor  	:= 5;
SET EstatusActivo   	:= 'A';
SET TipoUsuAnalista     := 'A';
SET TipoAsesor			:= 'AS';

SET EstatusVigente  	:= 'V';
SET Lis_Gestores    	:= 6;
SET Lis_Supervisor  	:= 7;
SET Lis_UserFR			:= 8;
SET Lis_GestProm        := 9;

SET Lis_UsuSupervisor   := 10;
SET Lis_UsuariosActivos	:= 11;
SET Lis_UsuAsamGral     := 14;
SET EstatusBloqueado	:= 'B';
SET Lis_UsuActBloq		:= 15;
SET Lis_AnalistasSol	:= 16;
SET Lis_RolAnalista     := 17;
SET Lis_RolCoordinador	:= 18;
SET Lis_RolAsesor		:= 19;
SET Lis_ConCorreo		:= 20;

SET Var_UsuID           :=0;
SET Var_NombreAnalistaV :='ANALISTA VIRTUAL';
SET Var_LlaveRolCoordinador		:= 'RolCoordinador';	-- Llave rol coordinador


IF(Par_NumLis = Lis_Principal) THEN
	SELECT 	U.UsuarioID,	U.NombreCompleto, S.NombreSucurs AS Sucursal,  U.Clave AS Clave

	FROM 		USUARIOS U
	LEFT OUTER JOIN SUCURSALES S ON U.SucursalUsuario = S.SucursalID
	WHERE `NombreCompleto` LIKE CONCAT("%", Par_NombUsuario, "%")

	LIMIT 0, 15;
END IF;

IF(Par_NumLis = Lis_PorSuc) THEN
	SELECT  U.UsuarioID, U.NombreCompleto,S.NombreSucurs AS Sucursal,  U.Clave AS Clave
	FROM CAJASVENTANILLA CV
	RIGHT JOIN USUARIOS U ON CV.UsuarioID=U.UsuarioID
	INNER JOIN SUCURSALES S ON U.SucursalUsuario=S.SucursalID
		WHERE CV.CajaID IS NULL
		 AND U.SucursalUsuario = Par_Sucursal
		 AND  U.Estatus = EstatusActivo
		 AND U.NombreCompleto LIKE CONCAT("%", Par_NombUsuario, "%")LIMIT 0, 15	;



END IF;

IF(Par_NumLis = Lis_UsuarioGestor) THEN
	SELECT Usu.UsuarioID, Usu.NombreCompleto
		FROM USUARIOS Usu
		INNER JOIN PUESTOS Pto ON Usu.ClavePuestoID = Pto.ClavePuestoID
		WHERE Pto.EsGestor = EsGestorSI
		LIMIT 0, 15;
END IF;

IF (Par_NumLis = Lis_Gestores) THEN
    SELECT usu.UsuarioID , usu.NombreCompleto
    FROM USUARIOS usu,
         PUESTOS pst
    WHERE usu.ClavePuestoID = pst.ClavePuestoID
    AND pst.EsGestor = EsGestorSI
    AND usu.Estatus =EstatusActivo AND pst.Estatus = EstatusVigente
	LIMIT 0,15;
END IF;


IF (Par_NumLis = Lis_Supervisor) THEN
     SELECT usu.UsuarioID, usu.NombreCompleto
    FROM USUARIOS usu,
         PUESTOS pst
    WHERE usu.ClavePuestoID = pst.ClavePuestoID
    AND pst.EsSupervisor = EsSupervisorSI
    AND usu.Estatus = EstatusActivo
	AND pst.Estatus = EstatusVigente
	LIMIT 0,15;
END IF;


IF (Par_NumLis = Lis_UserFR) THEN
    SELECT Usu.Clave AS UsuarioID , Usu.NombreCompleto
    FROM  USUARIOS Usu,
		  PARAMETROSCAJA Par,
		  CAJASVENTANILLA Caj
    WHERE Usu.Estatus = EstatusActivo
		AND Usu.RolID = Par.EjecutivoFR
		AND Usu.UsuarioID = Caj.UsuarioID
		AND Caj.Estatus = EstatusActivo;
END IF;

IF (Par_NumLis = Lis_GestProm) THEN
  SELECT Usu.UsuarioID,Usu.NombreCompleto
           FROM USUARIOS Usu,
                PUESTOS Pst
    WHERE Usu.NombreCompleto LIKE CONCAT("%", Par_NombUsuario, "%")
	AND Pst.ClavePuestoID = Usu.ClavePuestoID
    AND Pst.EsGestor = EsGestorSI
    AND Usu.Estatus = EstatusActivo
	AND Pst.Estatus = EstatusVigente
 ORDER BY Usu.UsuarioID
	LIMIT 0, 15;
END IF;


IF (Par_NumLis = Lis_UsuSupervisor) THEN
    SELECT usu.UsuarioID, usu.NombreCompleto
    FROM USUARIOS usu,
         PUESTOS pst
    WHERE  usu.NombreCompleto LIKE CONCAT("%", Par_NombUsuario, "%")
	AND usu.ClavePuestoID = pst.ClavePuestoID
    AND pst.EsSupervisor = EsSupervisorSI
    AND usu.Estatus = EstatusActivo
	AND pst.Estatus = EstatusVigente
	LIMIT 0,15;
END IF;



IF(Par_NumLis = Lis_UsuariosActivos) THEN
SELECT 	Usu.UsuarioID,  Usu.Clave, Usu.Estatus,  Usu.NombreCompleto, Usu.SucursalUsuario, Suc.NombreSucurs
		  FROM 	USUARIOS AS Usu
	INNER JOIN  SUCURSALES AS Suc ON Usu.SucursalUsuario = Suc.SucursalID
		 WHERE  Usu.Estatus = EstatusActivo
	  ORDER BY  Usu.SucursalUsuario;
END IF;


IF (Par_NumLis = Lis_UsuAsamGral) THEN
    SELECT usu.UsuarioID, usu.NombreCompleto
    FROM USUARIOS usu
    WHERE  usu.NombreCompleto LIKE CONCAT("%", Par_NombUsuario, "%")
    AND    usu.Estatus = EstatusActivo
	LIMIT 0,15;
END IF;


IF(Par_NumLis = Lis_UsuActBloq) THEN
	SELECT 	U.UsuarioID,	U.NombreCompleto, S.NombreSucurs AS Sucursal,  U.Clave AS Clave
	FROM 		USUARIOS U
	LEFT OUTER JOIN SUCURSALES S ON U.SucursalUsuario = S.SucursalID
	WHERE `NombreCompleto` LIKE CONCAT("%", Par_NombUsuario, "%")
	AND U.Estatus IN (EstatusActivo,EstatusBloqueado)
	LIMIT 0, 15;
END IF;


IF(Par_NumLis = Lis_AnalistasSol) THEN
(SELECT 	U.UsuarioID,	U.NombreCompleto, S.NombreSucurs AS Sucursal,  U.Clave AS Clave
	FROM 		USUARIOS U
    INNER JOIN PERFILESANALISTAS P ON P.RolID=U.RolID
	LEFT OUTER JOIN SUCURSALES S ON U.SucursalUsuario = S.SucursalID
	WHERE  P.TipoPerfil=TipoUsuAnalista AND`NombreCompleto` LIKE CONCAT("%",Par_NombUsuario, "%")
	LIMIT 0, 14)
UNION
(SELECT
	Var_UsuID, Var_NombreAnalistaV,Cadena_Vacia, Cadena_Vacia);

END IF;


IF(Par_NumLis = Lis_RolAnalista) THEN
SELECT 	U.UsuarioID,	U.NombreCompleto, S.NombreSucurs AS Sucursal,  U.Clave AS Clave
	FROM 		USUARIOS U
    INNER JOIN PERFILESANALISTAS P ON P.RolID=U.RolID
	LEFT OUTER JOIN SUCURSALES S ON U.SucursalUsuario = S.SucursalID
	WHERE  P.TipoPerfil=TipoUsuAnalista AND`NombreCompleto` LIKE CONCAT("%",Par_NombUsuario, "%")
	LIMIT 0, 14;
END IF;

-- 18.- Lista de usuarios coordinador
IF(Par_NumLis = Lis_RolCoordinador) THEN

	-- SE OBTIENE EL ROL CORRESPONDIENTE AL COORDINADOR
	SELECT	CAST(ValorParametro AS UNSIGNED)
	INTO	Var_RolCoordinador
	FROM PARAMGENERALES
	WHERE
		LlaveParametro = Var_LlaveRolCoordinador;

	-- VALIDACION DE DATOS NULOS
	SET Var_RolCoordinador := IFNULL(Var_RolCoordinador, Entero_Cero);

	SELECT 	U.UsuarioID,	U.NombreCompleto,	S.NombreSucurs AS Sucursal,	 U.Clave AS Clave
	FROM USUARIOS U
	INNER JOIN
		SUCURSALES S ON U.SucursalUsuario = S.SucursalID
	INNER JOIN
		ROLES Rol ON U.RolID = Rol.RolID
	WHERE `NombreCompleto` LIKE CONCAT("%", Par_NombUsuario, "%")
		AND Rol.RolID = Var_RolCoordinador
		AND U.Estatus = EstatusActivo
	LIMIT 0, 15;
END IF;

-- 18.- Lista de usuarios asesores
IF(Par_NumLis = Lis_RolAsesor) THEN

	SELECT U.UsuarioID,	U.NombreCompleto,	S.NombreSucurs AS Sucursal,	 U.Clave AS Clave
	FROM USUARIOS U
	INNER JOIN
		SUCURSALES S ON U.SucursalUsuario = S.SucursalID
	WHERE U.ClavePuestoID = TipoAsesor
		AND U.Estatus = EstatusActivo;
END IF;

-- 20.- Lista de usuarios asesores
IF(Par_NumLis = Lis_ConCorreo) THEN

	SELECT UsuarioID,	NombreCompleto
	FROM USUARIOS
	WHERE `NombreCompleto` LIKE CONCAT("%", Par_NombUsuario, "%")
		AND Estatus = EstatusActivo
		AND Correo != Cadena_Vacia;
END IF;

END TerminaStore$$
