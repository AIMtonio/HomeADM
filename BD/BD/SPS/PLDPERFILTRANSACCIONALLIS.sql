-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDPERFILTRANSACCIONALLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDPERFILTRANSACCIONALLIS`;
DELIMITER $$

CREATE PROCEDURE `PLDPERFILTRANSACCIONALLIS`(
-- SP para listar el Perfil Transaccional del Cliente o usuario d eservicios
	Par_NumLis						TINYINT UNSIGNED,			-- Numero de Lista
	Par_PersonaID					INT(11),					-- Numero de Cliente o usuario de servicios.
	Par_SucursalID					INT(11),					-- Numero de Sucursal
	Par_FechaInicio					DATE,						-- Fecha de Incio
	Par_FechaFin					DATE,						-- Fecha Fin

	-- Parametros de Auditoria
	Aud_EmpresaID					INT(11),
	Aud_Usuario						INT(11),
	Aud_FechaActual					DATETIME,
	Aud_DireccionIP					VARCHAR(15),
	Aud_ProgramaID					VARCHAR(50),
	Aud_Sucursal					INT(11),
	Aud_NumTransaccion				BIGINT(12)
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Sentencia			VARCHAR(10000);

	-- Declaracion de constantes
	DECLARE Entero_Cero				INT(11);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE	Fecha_Vacia				DATE;
	DECLARE Cons_NO					CHAR(1);
	DECLARE Pro_Manual				CHAR(1);

	DECLARE Lis_PrincipalCliente	INT(11);
	DECLARE Lis_Autoriza			INT(11);
	DECLARE Lis_PrincipalUsuario	INT(11);

	-- Asignaciom de constantes.
	SET Entero_Cero					:= 0;
	SET Cadena_Vacia				:= 'S';
	SET Fecha_Vacia					:= '1900-01-01';
	SET Cons_NO						:= 'S';
	SET Pro_Manual					:= 'M';

	SET Lis_PrincipalCliente		:= 1;
	SET Lis_Autoriza				:= 2;
	SET Lis_PrincipalUsuario		:= 3;			-- Lista principal perfil transaccional del usuario de servicios.

	IF(Par_NumLis = Lis_PrincipalCliente) THEN
		SELECT
			PLD.FechaAct as Fecha,			PLD.Hora,			PLD.ClienteID,					FORMAT(PLD.DepositosMax,2) AS DepositosMax,		FORMAT(PLD.RetirosMax,2) AS RetirosMax,
			PLD.NumDepositos,
			PLD.NumRetiros,				PLD.NumDepoApli,					PLD.NumRetiApli,		PLD.ComentarioOrigenRec,				PLD.ComentarioDestRec,
			PLD.CatOrigenRecID,		ORI.Descripcion AS DescripcionOrigen,PLD.CatDestinoRecID,	DES.Descripcion AS DescripcionDestino,
			IF(PLD.TipoProceso=Pro_Manual,'MANUAL','AUTOMATICO') AS TipoProceso
			FROM PLDHISPERFILTRANS AS PLD INNER JOIN
				CATPLDORIGENREC AS ORI ON PLD.CatOrigenRecID = ORI.CatOrigenRecID INNER JOIN
				CATPLDDESTINOREC AS DES ON PLD.CatDestinoRecID = DES.CatDestinoRecID
				WHERE
				ClienteID = Par_PersonaID
				ORDER BY PLD.FechaAct DESC, PLD.Hora DESC;
	END IF;

	IF(Par_NumLis = Lis_Autoriza) THEN
		SET Var_Sentencia := CONCAT('SELECT
			PLD.TransaccionID,						PLD.Fecha,			PLD.ClienteID,			CTE.NombreCompleto,			CTE.SucursalOrigen,
			SUC.NombreSucurs AS NombreSucursal,		IFNULL(PLD.DepositosMax, 0) AS DepositosMax,	IFNULL(PLD.RetirosMax, 0) AS RetirosMax,			IFNULL(PLD.NumDepositos, 0) AS NumDepositos,
			IFNULL(PLD.NumRetiros, 0) AS NumRetiros
			FROM PLDPERFILTRANSREAL AS PLD INNER JOIN
				CLIENTES AS CTE ON PLD.ClienteID = CTE.ClienteID INNER JOIN
				SUCURSALES AS SUC ON CTE.SucursalOrigen = SUC.SucursalID
			WHERE (IFNULL(PLD.DepositosMax, 0)>PLD.AntDepositosMax OR
					IFNULL(PLD.RetirosMax, 0)>PLD.AntRetirosMax OR
					IFNULL(PLD.NumRetiros, 0)>PLD.AntNumRetiros OR
					IFNULL(PLD.NumDepositos, 0)>PLD.AntNumDepositos) ');
		IF(IFNULL(Par_PersonaID,Entero_Cero)>Entero_Cero) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,' AND PLD.ClienteID = ',Par_PersonaID);
			IF(IFNULL(Par_FechaInicio,Fecha_Vacia)!=Fecha_Vacia AND IFNULL(Par_FechaFin,Fecha_Vacia)!=Fecha_Vacia) THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia,' AND PLD.Fecha BETWEEN \'',Par_FechaInicio,'\' AND \'', Par_FechaFin,'\'');
			END IF;
		ELSEIF(IFNULL(Par_SucursalID,Entero_Cero)>Entero_Cero) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,' AND SUC.SucursalID = ',Par_SucursalID);

			IF(IFNULL(Par_FechaInicio,Fecha_Vacia)!=Fecha_Vacia AND IFNULL(Par_FechaFin,Fecha_Vacia)!=Fecha_Vacia) THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia,' AND PLD.Fecha BETWEEN \'',Par_FechaInicio,'\' AND \'', Par_FechaFin,'\'');
			END IF;
		ELSE
			IF(IFNULL(Par_FechaInicio,Fecha_Vacia)!=Fecha_Vacia AND IFNULL(Par_FechaFin,Fecha_Vacia)!=Fecha_Vacia) THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia,' AND PLD.Fecha BETWEEN \'',Par_FechaInicio,'\' AND \'', Par_FechaFin,'\'');
			END IF;
		END IF;

		SET Var_Sentencia := CONCAT(Var_Sentencia,';');
		SET @Sentencia	:= CONCAT(Var_Sentencia);
		PREPARE PLDLISTA FROM @Sentencia;
		EXECUTE PLDLISTA;
		DEALLOCATE PREPARE PLDLISTA;

	END IF;


	-- 3. Lista perfil transaccional del usuario de servicios.
	-- Pantalla: Prevencion LD > Registro > Perfil Transaccional.
	IF (Par_NumLis = Lis_PrincipalUsuario) THEN
		SELECT
			PH.FechaAct as Fecha, PH.Hora,							   PH.UsuarioServicioID, FORMAT(PH.DepositosMax,2) AS DepositosMax, FORMAT(PH.RetirosMax,2) AS RetirosMax,
			PH.NumDepositos,	  PH.NumRetiros,					   PH.NumDepoApli,		 PH.NumRetiApli,							PH.ComentarioOrigenRec,
			PH.NumRetiros,		  PH.NumDepoApli,					   PH.NumRetiApli,	  	 PH.ComentarioOrigenRec,					PH.ComentarioDestRec,
			PH.CatOrigenRecID,	  CA.Descripcion AS DescripcionOrigen, PH.CatDestinoRecID, 	 CD.Descripcion AS DescripcionDestino,		IF(PH.TipoProceso=Pro_Manual,'MANUAL','AUTOMATICO') AS TipoProceso
		FROM PLDHISPERFILTRANS AS PH
		INNER JOIN CATPLDORIGENREC AS CA ON CA.CatOrigenRecID = PH.CatOrigenRecID
		INNER JOIN CATPLDDESTINOREC AS CD ON CD.CatDestinoRecID = PH.CatDestinoRecID
		WHERE PH.UsuarioServicioID = Par_PersonaID
		ORDER BY PH.FechaAct DESC, PH.Hora DESC;
	END IF;

END TerminaStore$$