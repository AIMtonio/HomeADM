-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTEEXPEDIENTECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTEEXPEDIENTECON`;
DELIMITER $$


CREATE PROCEDURE `CLIENTEEXPEDIENTECON`(
	Par_ClienteID 			INT(11),
    Par_NumCon 				INT,

	Aud_EmpresaID			INT(11),
	Aud_Usuario         	INT(11),
	Aud_FechaActual     	DATETIME,
	Aud_DireccionIP     	VARCHAR(20),
	Aud_ProgramaID      	VARCHAR(50),
	Aud_Sucursal        	INT(11),
	Aud_NumTransaccion  	BIGINT(20)
	)

TerminaStore:BEGIN

	-- Declaracion de Constantes
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Entero_Cero			INT;
DECLARE Entero_Uno			INT;
DECLARE Decimal_Cero		DECIMAL;
DECLARE Fecha_Vacia			DATE;
DECLARE SalidaSI			CHAR(1);
DECLARE SalidaNO			CHAR(1);
DECLARE Con_Princ			INT;
DECLARE Con_TiempoActCte	INT;
DECLARE EstatusInact		CHAR(1);
DECLARE EstatusAct			CHAR(1);
DECLARE NivelBajo			CHAR(1);
DECLARE NivelAlto			CHAR(1);
DECLARE NivelMedio			CHAR(1);

	-- Declaracion de Variables
DECLARE Var_ClienteID		INT(11);
DECLARE Var_FechaSis		DATE;
DECLARE Var_FechaExp		DATE;
DECLARE Var_TiempoAct		INT;
DECLARE Var_EstatusCte		CHAR(1);
DECLARE Var_NivelRiesgoCte	CHAR(1);

	-- Asignacion de Constantes
SET Cadena_Vacia		:='';		-- Cadena Vacia
SET Entero_Cero			:= 0;		-- Entero Cero
SET Entero_Uno			:= 1;		-- Entero uno
SET Decimal_Cero		:= 0.0;		-- Decimal Cero
SET Fecha_Vacia			:='1900-01-01';-- Fecha Vacia
SET SalidaSI			:='S';		-- Salida SI
SET SalidaNO			:='N';		-- Salida NO
SET Con_Princ			:= 1;		-- Consulta Principal
SET Con_TiempoActCte	:= 2;		-- Consulta que se usa en el flujo del cliente y en las operaciones de ventanilla
SET EstatusAct			:='A';		-- Estatus Activo
SET EstatusInact		:='I';		-- Estatus Inactivo
SET NivelBajo			:='B';		-- Nivel de Riesgo BAJO
SET NivelAlto			:='A';		-- Nivel de Riesgo ALTO
SET NivelMedio			:='M';		-- Nivel de Riesgo MEDIO

SELECT FechaSistema INTO Var_FechaSis
	FROM PARAMETROSSIS;

-- Consulta para la pantalla de Actualización del Cliente
IF(IFNULL(Par_NumCon,Entero_Cero)=Con_Princ) THEN
	SELECT 	CliExp.ClienteID, 	CL.NombreCompleto ClienteNombre, u.NombreCompleto UsuarioNombre, FechaExpediente, CliExp.FechaActual
		FROM  CLIENTES CL INNER JOIN  CLIENTEEXPEDIENTE CliExp ON(CL.ClienteID=CliExp.ClienteID)
			INNER JOIN USUARIOS u ON(CliExp.Usuario=u.UsuarioID)
			WHERE CliExp.ClienteID = Par_ClienteID
            ORDER BY CliExp.FechaActual DESC LIMIT 1;
END IF;

-- Consulta pare flujo de Cliente o Opraciones en Ventanilla
IF(IFNULL(Par_NumCon,Entero_Cero)=Con_TiempoActCte) THEN
	SELECT 	CliExp.ClienteID, CliExp.FechaExpediente
    INTO 	Var_ClienteID, Var_FechaExp
		FROM CLIENTEEXPEDIENTE CliExp
			WHERE CliExp.ClienteID = Par_ClienteID
            ORDER BY CliExp.FechaActual DESC LIMIT 1;

    SELECT Estatus, 		NivelRiesgo
    INTO Var_EstatusCte,	Var_NivelRiesgoCte
		FROM CLIENTES
			WHERE ClienteID = Par_ClienteID;

    SET Var_ClienteID		:= IFNULL(Var_ClienteID,Entero_Cero);
    SET Var_FechaExp		:= IFNULL(Var_FechaExp,Fecha_Vacia);
    SET Var_EstatusCte		:= IFNULL(Var_EstatusCte,EstatusAct);
    SET Var_NivelRiesgoCte	:= IFNULL(Var_NivelRiesgoCte,NivelBajo);
    -- NOS ASEGURAMOS DE QUE HAYA UN ESTATUS Y UN NIVEL DE RIESGO DEFAULT
    SET Var_EstatusCte		:= IF(Var_EstatusCte=Cadena_Vacia,EstatusAct,Var_EstatusCte);
    SET Var_NivelRiesgoCte	:= IF(Var_NivelRiesgoCte=Cadena_Vacia,NivelBajo,Var_NivelRiesgoCte);

    IF(Var_EstatusCte=EstatusAct AND Var_NivelRiesgoCte=NivelAlto)THEN
		-- Si el estatus del cliente es ACTIVO se calcula el tiempo que tiene el expediente
		SELECT 	Var_ClienteID AS ClienteID, Var_FechaExp AS FechaExpediente,
				TIMESTAMPDIFF(YEAR, Var_FechaExp, Var_FechaSis) AS Tiempo;
	ELSE
		-- Si esta INACTIVO y no es de RIESGO ALTO se envia como si ya estuviera actualizado
		SELECT 	Var_ClienteID AS ClienteID, Var_FechaExp AS FechaExpediente,
				Entero_Cero AS Tiempo;
	END IF;
END IF;

END TerminaStore$$