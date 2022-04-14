-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARCHIVOCARGADEPREFCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARCHIVOCARGADEPREFCON`;DELIMITER $$

CREATE PROCEDURE `ARCHIVOCARGADEPREFCON`(
	/* CONSULTA DEL ARCHIVO DE CARGA PARA LOS DEPÓSITOS REFERENCIADOS. */
	Par_InstitucionID		INT(11),			-- ID DE LA INSTITUCIÓN BANCARIA.
	Par_NumCtaInstit		VARCHAR(20),		-- NÚMERO DE CTA DE LA INST. BANCARIA.
	Par_NumTransaccion		BIGINT(20),			-- NÚMERO DE TRANSACCIÓN.
	Par_NumCon				TINYINT UNSIGNED,	-- NÚMERO DE CONSULTA.
	/* Parámetros de Auditoría */
	Par_EmpresaID			INT(11),

	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),

	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN
-- Declaración de Constantes.
DECLARE Con_Validaciones	INT(11);
DECLARE Estatus_NI			CHAR(2);

-- Asignación de Constantes.
SET Con_Validaciones := 1;			-- Consulta el numero de las validaciones de la tabla temporal
SET Estatus_NI		 := 'NI';		-- Estatus no Identificado

IF(Par_NumCon = Con_Validaciones) THEN
	SELECT GROUP_CONCAT(CONCAT('',NumVal,'')) AS Validaciones
		FROM ARCHIVOCARGADEPREF
			WHERE InstitucionID = Par_InstitucionID
				AND CuentaAhoID = Par_NumCtaInstit
	            AND NumTran = Par_NumTransaccion
				AND Estatus = Estatus_NI;
END IF;

END TerminaStore$$