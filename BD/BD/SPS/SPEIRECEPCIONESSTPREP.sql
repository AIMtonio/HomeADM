-- SPEIRECEPCIONESSTPREP
DELIMITER ;

DROP PROCEDURE IF EXISTS `SPEIRECEPCIONESSTPREP`;

DELIMITER $$

CREATE PROCEDURE `SPEIRECEPCIONESSTPREP`(
	-- STORED PROCEDURE PARA GENERAR EL REPORTE DE SPEIRECEPCIONES
	Par_FechaInicio			DATE,					-- Fecha Inicio que se comparara con el campo FechaOperacion
	Par_FechaFin 			DATE,					-- Fecha Fin que se comparara con el campo FechaOperacion
	Par_MontoMin			DOUBLE(12,2),			-- Rango inicial que se comparara con el campo MontoTransferir
	Par_MontoMax			DOUBLE(12,2),			-- Rango final que se comparara con el campo MontoTransferir

	-- Parametros de Auditoria
	Par_EmpresaID			INT(11),				-- Parametro de Auditoria
	Aud_Usuario				INT(11),				-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,				-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),			-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),			-- Parametro de Auditoria
	Aud_Sucursal			INT(11),				-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)				-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Sentencia 			VARCHAR(9000);	-- Sentencia de consulta a ejecutar

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia			CHAR(1);		-- Cadena vacia
	DECLARE Entero_Cero				INT(11);		-- Entero vacio
	DECLARE Decimal_Cero			DECIMAL(14,2);	-- Decimal vacio

	-- Asignacion de Constantes
	SET Cadena_Vacia				:= '';			-- Cadena  vacia
	SET Entero_Cero					:= 0;			-- Entero vacio
	SET Decimal_Cero				:= 0.00;		-- Decimal vacio

	SET Var_Sentencia :=
		"SELECT	SRECEP.FolioSpeiRecID,										SRECEP.ClaveRastreo,											TPAGO.Descripcion AS TipoPago,
				FNDECRYPTSAFI(SRECEP.NombreOrd) AS NombreOrd,				FNDECRYPTSAFI(SRECEP.CuentaOrd) AS CuentaOrd,					FNDECRYPTSAFI(SRECEP.ConceptoPago) AS ConceptoPago,
				FNDECRYPTSAFI(SRECEP.MontoTransferir) AS MontoTransferir,	SRECEP.IVAComision,												INSREM.Descripcion AS InstiRemitente,
				INSREC.Descripcion AS InstiReceptora,						FNDECRYPTSAFI(SRECEP.CuentaBeneficiario) AS CuentaBeneficiario,	FNDECRYPTSAFI(SRECEP.NombreBeneficiario) AS NombreBeneficiario,
				SRECEP.FechaCaptura,										CDEV.Descripcion AS CausaDevol,
				CASE
					WHEN SRECEP.Estatus = 'R' THEN 'REGISTRADA'
					WHEN SRECEP.Estatus = 'A' THEN 'ABONADA'
					WHEN SRECEP.Estatus = 'D' THEN 'DEVUELTA'
				END AS Estatus ";

	SET Var_Sentencia	:= CONCAT(Var_Sentencia,' FROM SPEIRECEPCIONES SRECEP');
	SET Var_Sentencia	:= CONCAT(Var_Sentencia,' INNER JOIN INSTITUCIONESSPEI INSREM ON SRECEP.InstiRemitenteID = INSREM.InstitucionID ');
	SET Var_Sentencia	:= CONCAT(Var_Sentencia,' INNER JOIN INSTITUCIONESSPEI INSREC ON SRECEP.InstiReceptoraID = INSREC.InstitucionID ');
	SET Var_Sentencia	:= CONCAT(Var_Sentencia,' INNER JOIN TIPOSPAGOSPEI TPAGO ON TPAGO.TipoPagoID = SRECEP.TipoPagoID ');
	SET Var_Sentencia	:= CONCAT(Var_Sentencia,' INNER JOIN CAUSASDEVSPEI CDEV ON SRECEP.CausaDevol = CDEV.CausaDevID ');
	SET Var_Sentencia	:= CONCAT(Var_Sentencia,' WHERE SRECEP.FechaCaptura between ? AND ? AND FNDECRYPTSAFI(SRECEP.MontoTransferir) >= ? AND FNDECRYPTSAFI(SRECEP.MontoTransferir) <= ?;');

	SET @Sentencia		= (Var_Sentencia);
	SET @FechaInicio	= Par_FechaInicio;
	SET @FechaFin		= Par_FechaFin;
	SET @MontoMin 		= Par_MontoMin;
	SET @MontoMax 		= Par_MontoMax;

	PREPARE SPEIRECEPCIONESSTPREP FROM @Sentencia;
	EXECUTE SPEIRECEPCIONESSTPREP USING @FechaInicio,@FechaFin,@MontoMin,@MontoMax ;
	DEALLOCATE PREPARE SPEIRECEPCIONESSTPREP;

-- Fin de SP
END TerminaStore$$