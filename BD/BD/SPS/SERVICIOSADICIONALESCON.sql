
-- SP SERVICIOSADICIONALESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS SERVICIOSADICIONALESCON;

DELIMITER $$
CREATE PROCEDURE SERVICIOSADICIONALESCON(
	Par_ServicioID			INT(11),
	Par_Descripcion			VARCHAR(8000),
	Par_NumCon				TINYINT UNSIGNED,

	/* Parametros de Auditoria */
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT
)

TerminaStore : BEGIN

	-- Declaraciòn de constantes
	DECLARE Cons_ServicioID		INT(11);
	DECLARE Cons_EmpresasID		INT(11);
	DECLARE Cons_ValidaNom 		INT(11);
	DECLARE Cons_SinCondNom		CHAR(1);
	DECLARE Cons_ConCondNom		CHAR(1);
	DECLARE Cons_NoEsNomina		CHAR(1);
	DECLARE Cons_ProdSINConv	INT;
	DECLARE Cons_ProdCONConv	INT;

    DECLARE Con_EstatusA		CHAR(1);
    DECLARE Var_EmpresasID		VARCHAR(8000);
    DECLARE Var_ProductosID		VARCHAR(8000);
    DECLARE Var_Sentencia		VARCHAR(2000);

	-- Seteo de constantes
	SET Cons_ServicioID		:= 1;			-- Consulta Principal
	SET Cons_EmpresasID		:= 2;			-- Consullta por Empresa
	SET Cons_ValidaNom		:= 3;			-- Consulta por Producto para identificar si exista la configuracion de nomina
	SET Con_EstatusA		:= 'A';			-- Estatus Activo
	SET Cons_SinCondNom		:= 'E';			-- Constante para indicar que Existe un Producto de Nomina Sin Configuracion de Convenios
	SET Cons_ConCondNom		:= 'S';			-- Constante para indicar que todos los productos tienen configurado convenios de nomnina
	SET Cons_NoEsNomina		:= 'N';			-- Constanate para indicar que los productos no son de nomina
	SET Cons_ProdSINConv	:= 3;			-- Constante para indicar los productos que no tienen convenio
	SET Cons_ProdCONConv	:= 2;			-- Constante para indicar los productos con convenio


	SET Var_Sentencia 		:= ''; 			-- Inicialicia la sentencia

	IF(Par_NumCon = Cons_ServicioID) THEN

		SELECT GROUP_CONCAT(SxE.InstitNominaID) INTO Var_EmpresasID
		  FROM SERVICIOSADICIONALES AS SA
		 INNER JOIN SERVICIOSXEMPRESA SxE ON SA.ServicioID = SxE.ServicioID
		 WHERE SA.ServicioID = Par_ServicioID;

		SELECT GROUP_CONCAT(SxP.ProducCreditoID) INTO Var_ProductosID
		  FROM SERVICIOSADICIONALES AS SA
		 INNER JOIN SERVICIOSXPRODUCTO SxP ON SA.ServicioID = SxP.ServicioID
		 WHERE SA.ServicioID = Par_ServicioID;

		SELECT ServicioID, Descripcion, ValidaDocs, TipoDocumento  ,IFNULL(Var_EmpresasID,'') AS EmpresasID  , IFNULL(Var_ProductosID,'') AS ProductosID
		  FROM SERVICIOSADICIONALES
		 WHERE Estatus = Con_EstatusA
           AND ServicioID = Par_ServicioID;

	END IF;

	IF(Par_NumCon = Cons_ValidaNom) THEN

		DROP TEMPORARY TABLE IF EXISTS TMPPRODCONVENIO;

		CREATE TEMPORARY TABLE TMPPRODCONVENIO(
				ProducCreditoID 		INT(11) COMMENT 'Numero de Tipo de Producto',
				ValidacionNomina		INT(11) COMMENT 'Campo de Paso para Validar Si tienen configuracion Convenio'
		);

		SET Var_Sentencia := 'INSERT INTO TMPPRODCONVENIO(
				ProducCreditoID, ValidacionNomina)
		   SELECT
				Pro.ProducCreditoID,
		         CASE WHEN (Pro.ProductoNomina = \'S\'  AND IFNULL(CPro.ProducCreditoID,0) = 0 ) THEN 3  -- Nomina SIn Convenio
							WHEN (Pro.ProductoNomina = \'S\'  AND IFNULL(CPro.ProducCreditoID,0) != 0 ) THEN 2 -- Nomina Con Convenio
		                    ELSE  1   -- SIN NOMINA
		         END AS ValidacionNomina
		         FROM PRODUCTOSCREDITO Pro
								LEFT JOIN NOMCONDICIONCRED CPro ON CPro.ProducCreditoID = Pro.ProducCreditoID
								LEFT JOIN INSTITNOMINA Ins  ON CPro.InstitNominaID = Ins.InstitNominaID
															AND Ins.Estatus = \'A\'
								WHERE Pro.ProducCreditoID IN (';
		SET Var_Sentencia := CONCAT(Var_Sentencia,Par_Descripcion,')');

		SET @Sentencia 	:= (Var_Sentencia);
		PREPARE EjecutaConValNom FROM @Sentencia;
		EXECUTE  EjecutaConValNom;
		DEALLOCATE PREPARE EjecutaConValNom;

		SELECT
			CASE
				WHEN MAX(ValidacionNomina) = Cons_ProdSINConv THEN Cons_SinCondNom
				WHEN MAX(ValidacionNomina) = Cons_ProdCONConv THEN Cons_ConCondNom
				ELSE Cons_NoEsNomina END AS ValidoNomina
			FROM TMPPRODCONVENIO;

		DROP TEMPORARY TABLE IF EXISTS TMPPRODCONVENIO;

	END IF;

END  TerminaStore$$