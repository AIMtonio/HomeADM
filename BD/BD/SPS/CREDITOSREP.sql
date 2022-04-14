-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSREP`;
DELIMITER $$


CREATE PROCEDURE `CREDITOSREP`(




	Par_ClienteID			INT(11),
	Par_Estatus				CHAR(1),

	Par_NumRep			TINYINT UNSIGNED,

	Par_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
	)

TerminaStore: BEGIN


	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE	Rep_Principal		INT;
	DECLARE Est_Inactivo		CHAR(1);
	DECLARE Est_InactivoDes		CHAR(15);
	DECLARE Est_Autorizado		CHAR(1);
    DECLARE Est_AutorizadoDes	CHAR(15);
	DECLARE Est_Pagado			CHAR(1);
	DECLARE Est_PagadoDes		CHAR(15);
    DECLARE Est_Castigado		CHAR(1);
	DECLARE Est_CastigadoDes	CHAR(15);
    DECLARE Est_Vigente			CHAR(1);
	DECLARE Est_VigenteDes		CHAR(15);
    DECLARE Est_Vencido			CHAR(1);
	DECLARE Est_VencidoDes		CHAR(15);
	DECLARE Est_Suspendido		CHAR(1);
	DECLARE Est_SuspendidoDes	CHAR(15);
	DECLARE NoAsignado			CHAR(4);



DECLARE Var_Sentencia	VARCHAR(9000);


SET	Cadena_Vacia		:= '';
SET	Fecha_Vacia			:= '1900-01-01';
SET	Entero_Cero			:= 0;
SET	Rep_Principal		:= 1;

	SET Est_Inactivo		:= 'I';
	SET Est_InactivoDes		:= 'INACTIVO';
	SET Est_Autorizado		:= 'A';
    SET Est_AutorizadoDes	:= 'AUTORIZADO';
	SET Est_Pagado			:= 'P';
	SET Est_PagadoDes		:= 'PAGADO';
    SET Est_Castigado		:= 'K';
	SET Est_CastigadoDes	:= 'CASTIGADO';
    SET Est_Vigente			:= 'V';
	SET Est_VigenteDes		:= 'VIGENTE';
    SET Est_Vencido			:= 'B';
	SET Est_VencidoDes		:= 'VENCIDO';
    SET Est_Suspendido		:= 'S';
	SET Est_SuspendidoDes	:= 'SUSPENDIDO';
	SET NoAsignado			:= 'NA';

IF(Par_NumRep = Rep_Principal) THEN

	SET Var_Sentencia :=  'SELECT Cre.CreditoID,  Cli.ClienteID,  Cli.NombreCompleto AS NombreCliente,  Pro.ProducCreditoID,
								  Cre.MontoCredito, Pro.Descripcion AS ProductoCredito, Suc.NombreSucurs, Cre.FechaVencimien,
								  Pla.Descripcion AS Plazo,  Cre.FechaMinistrado AS FechaDesembolso, CONVERT(Cre.FechTerminacion, CHAR(10)) AS FechTerminacion ,
								  CONVERT(IFNULL(Gru.GrupoID,""), CHAR(11)) AS GrupoID, ';

	SET Var_Sentencia :=  CONCAT(Var_Sentencia,' CASE IFNULL(Gru.NombreGrupo,"") ');
	SET Var_Sentencia :=  CONCAT(Var_Sentencia,' WHEN "', '', '" THEN "',NoAsignado ,'"');
	SET Var_Sentencia :=  CONCAT(Var_Sentencia,' ELSE  CONCAT(Gru.NombreGrupo) ');
	SET Var_Sentencia :=  CONCAT(Var_Sentencia,' END AS NombreGrupo,');

	SET Var_Sentencia :=  CONCAT(Var_Sentencia,' CASE Cre.Estatus ');
	SET Var_Sentencia :=  CONCAT(Var_Sentencia,' WHEN "', Est_Inactivo, '" THEN "',Est_InactivoDes ,'"');
	SET Var_Sentencia :=  CONCAT(Var_Sentencia,' WHEN "', Est_Autorizado,'"	 THEN "',Est_AutorizadoDes ,'"');
	SET Var_Sentencia :=  CONCAT(Var_Sentencia,' WHEN "', Est_Pagado,'"		 THEN "',Est_PagadoDes ,'"');
    SET Var_Sentencia :=  CONCAT(Var_Sentencia,' WHEN "', Est_Castigado,'"	 THEN "',Est_CastigadoDes ,'"');
    SET Var_Sentencia :=  CONCAT(Var_Sentencia,' WHEN "', Est_Vigente,'"	 THEN "',Est_VigenteDes ,'"');
    SET Var_Sentencia :=  CONCAT(Var_Sentencia,' WHEN "', Est_Vencido,'"	 THEN "',Est_VencidoDes ,'"');
	SET Var_Sentencia :=  CONCAT(Var_Sentencia,' WHEN "', Est_Suspendido,'"	 THEN "',Est_SuspendidoDes ,'"');
	SET Var_Sentencia :=  CONCAT(Var_Sentencia,' ELSE Cre.Estatus ');
	SET Var_Sentencia :=  CONCAT(Var_Sentencia,' END AS Estatus');

	SET Var_Sentencia :=  CONCAT(Var_Sentencia,' FROM CREDITOS Cre
												 LEFT JOIN GRUPOSCREDITO Gru ON Cre.GrupoID= Gru.GrupoID,
												 PRODUCTOSCREDITO Pro,
												 CLIENTES Cli,
												 SUCURSALES Suc,
												 CREDITOSPLAZOS Pla');

	SET Var_Sentencia :=  CONCAT(Var_Sentencia,' WHERE Cre.ClienteID = Cli.ClienteID
												 AND Cre.ProductoCreditoID = Pro.ProducCreditoID
												 AND Cre.SucursalID = Suc.SucursalID
												 AND Cre.PlazoID = Pla.PlazoID
												 AND Cre.ClienteID =', Par_ClienteID);

	IF(IFNULL(Par_Estatus,Cadena_Vacia) != Cadena_Vacia)THEN
        SET Var_Sentencia :=  CONCAT(Var_Sentencia,' AND Cre.Estatus = "', Par_Estatus,'"');
    END IF;

	SET Var_Sentencia :=  CONCAT(Var_Sentencia,' ORDER BY  Cre.CreditoID;');

	SET @Sentencia	= (Var_Sentencia);

	PREPARE STCREDITOSREP FROM @Sentencia;
	EXECUTE STCREDITOSREP;

	DEALLOCATE PREPARE STCREDITOSREP;

END IF;

END TerminaStore$$