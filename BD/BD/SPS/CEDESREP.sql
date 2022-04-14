-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CEDESREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CEDESREP`;DELIMITER $$

CREATE PROCEDURE `CEDESREP`(
    /*SP QUE GENERA EL REPORTE DE CEDES VIGENTES*/
    Par_TipoCedeID      INT,
    Par_PromotorID      INT,
    Par_SucursalID      INT,
    Par_ClienteID       INT,
    Par_FechaApertura   DATE,

    Par_NumRep          INT,
    Aud_EmpresaID       INT,
    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),

    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
)
TerminaStore: BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE Fecha_Vacia     DATE;
	DECLARE Entero_Cero     INT;
	DECLARE Estatus_Vig     CHAR(1);

	-- DECLARACION DE VARIABLES
	DECLARE Var_Sentencia   VARCHAR(3000);

	-- Asignacion de CONSTANTES
	SET Fecha_Vacia         := '1900-01-01';-- fecha para valores vacios
	SET Entero_Cero         := 0;  			-- Constante Valor Cero
	SET Estatus_Vig         := 'N';			-- Estatus Vigente de una Cede

	-- Asignacion de VARIABLES

	SET Var_Sentencia :=    ( 'SELECT   Ce.CedeID,      Ce.TipoCedeID,      Ti.Descripcion AS DescripcionCede,      Ce.CuentaAhoID,     Ce.ClienteID,
										Ce.FechaInicio, Ce.FechaVencimiento,Ce.Monto,           Ce.Plazo,           Ce.TasaFija,
										Ce.TasaISR,     Ce.Estatus,         Ce.FechaApertura,   Ti.TasaFV,          Ti.Descripcion,
										Ce.CalculoInteres,  CASE Ce.CalculoInteres  WHEN "1" THEN   "Tasa Fija"
																					WHEN "2" THEN   "Tasa Inicio Mes + Puntos"
																					ELSE    "No Definido" END AS FormulaInteres,
										Ce.SobreTasa,           Ce.PisoTasa,        Ce.TechoTasa,       Ce.TasaBase,        IFNULL(Tb.Nombre,   "NA") AS TasaBaseDes,
										Cl.NombreCompleto,
										Cl.SucursalOrigen,      Su.NombreSucurs,    Cl.PromotorActual,  Pr.NombrePromotor
									FROM    CEDES       Ce
										INNER JOIN TIPOSCEDES   Ti  ON (    Ce.TipoCedeID       =   Ti.TipoCedeID ');

	/* SE COMPARA PARA SABER SI SE RECIBE UN TIPO DE CEDE */
	IF(IFNULL(Par_TipoCedeID, Entero_Cero) > Entero_Cero) THEN
		SET Var_Sentencia :=  CONCAT(Var_Sentencia,  ' AND  Ce.TipoCedeID       =   ',Par_TipoCedeID, ' ' );
	END IF;

	SET Var_Sentencia :=  CONCAT(Var_Sentencia,  ' )
						INNER JOIN CLIENTES     Cl  ON (    Ce.ClienteID        =   Cl.ClienteID ');

	/* SE COMPARA PARA SABER SI SE RECIBE UN numero de cliente */
	IF(IFNULL(Par_ClienteID, Entero_Cero) > Entero_Cero) THEN
		SET Var_Sentencia :=  CONCAT(Var_Sentencia,  ' AND  Ce.ClienteID        =   ',Par_ClienteID, ' ' );
	END IF;

	SET Var_Sentencia :=  CONCAT(Var_Sentencia,  ' )

					INNER JOIN SUCURSALES   Su  ON (    Cl.SucursalOrigen   =   Su.SucursalID ');

	/* SE COMPARA PARA SABER SI SE RECIBE UN numero de SUCURSAL */
	IF(IFNULL(Par_SucursalID, Entero_Cero) > Entero_Cero) THEN
		SET Var_Sentencia :=  CONCAT(Var_Sentencia,  ' AND  Cl.SucursalOrigen       =   ',Par_SucursalID, ' ' );
	END IF;

	SET Var_Sentencia :=  CONCAT(Var_Sentencia,  ' )
					INNER JOIN PROMOTORES   Pr  ON (    Cl.PromotorActual   =   Pr.PromotorID ');

	/* SE COMPARA PARA SABER SI SE RECIBE UN numero de PROMOTOR */
	IF(IFNULL(Par_PromotorID, Entero_Cero) > Entero_Cero) THEN
		SET Var_Sentencia :=  CONCAT(Var_Sentencia,  ' AND  Cl.PromotorActual       =   ',Par_PromotorID, ' ' );
	END IF;

	SET Var_Sentencia :=  CONCAT(Var_Sentencia,  ' )
					LEFT JOIN TASASBASE Tb  ON  (   Ce.TasaBase         =   Tb.TasaBaseID) ');

	/* SE COMPARA PARA SABER SI SE RECIBE UNA FECHA DE APERTURA  */
	IF(IFNULL(Par_FechaApertura, Fecha_Vacia) > Fecha_Vacia) THEN
		SET Var_Sentencia :=  CONCAT(Var_Sentencia,  ' WHERE    Ce.FechaApertura    <=  "',Par_FechaApertura, '" ' );
	END IF;

	SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' AND  Ce.Estatus="',Estatus_Vig,'" ORDER BY Cl.SucursalOrigen, Ce.ClienteID, Cl.PromotorActual; ');

	SET @Sentencia  = (Var_Sentencia);

	PREPARE SPCEDESREP FROM @Sentencia;
	EXECUTE SPCEDESREP;
	DEALLOCATE PREPARE SPCEDESREP;


END TerminaStore$$