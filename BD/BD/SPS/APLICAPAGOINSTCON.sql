-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APLICAPAGOINSTCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `APLICAPAGOINSTCON`;
DELIMITER $$

CREATE PROCEDURE `APLICAPAGOINSTCON`(
	Par_FolioNum		INT(11),			-- numero de folio
	Par_EmpresanominaID	INT(11),			-- Empresa de nomina
	Par_NumCon			TINYINT UNSIGNED,	-- Numero de consulta

	Par_EmpresaID		INT(11),			-- Parametro de auditoria
	Aud_Usuario			INT(11),			-- Parametro de auditoria
	Aud_FechaActual		DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal		INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion	BIGINT				-- Parametro de auditoria
	)
TerminaStore: BEGIN

-- DECLARACION DE VARIABLES
DECLARE Var_InstitNominaID  VARCHAR(20);	-- ID de la institucion de nomina
DECLARE Var_BancoDeposito	INT(11);		-- Banco de deposito
DECLARE Var_CuentaDeposito	INT(11);		-- Cuenta de deposito
DECLARE Var_TotalFolio		INT(11);		-- Total de registros del folio
DECLARE Var_TotalAplicado	INT(11);		-- Total de registros del folio aplicados
DECLARE Var_Estatus			VARCHAR(20);	-- Estatus de pago de la institucion
DECLARE Var_MontoApli		DECIMAL(12,2);	-- Monto Total Apli

-- DECLARACION DE CONSTANTES
DECLARE		Con_Principal	INT(11);		-- Consulta prncipal
DECLARE		Con_Foranea		INT(11);		-- Cosnulta foranea
DECLARE		Con_NomIns		INT(11);		-- Consulta institucion
DECLARE 	Con_Promotor	INT(11);		-- Consulta promotor
DECLARE 	Con_MovTeso		INT(11);		-- Consulta movimiento de tesoreria
DECLARE		Con_Cte			INT(11);		-- Consulta cliente
DECLARE		Con_Correo		INT(11);		-- Consulta correo
DECLARE		Con_NumEmpleado	INT(11);		-- Consulta empleado
DECLARE		Est_Aplicado	CHAR(1);		-- Estatus aplicado
DECLARE		Est_Vigente		CHAR(1);		-- Estatus vigente
DECLARE		Desc_Aplicado	VARCHAR(20);	-- Descripcion aplicado
DECLARE		Desc_Pendiente	VARCHAR(20);	-- Descripcion pendiente
DECLARE		Est_Procesado	CHAR(1);		-- Estatus Procesado
DECLARE		Cadena_Vacia	CHAR(1);		-- Cadena Vacia
DECLARE		Con_MontoApli	INT(11);		-- Consulta Monto Aplicado
DECLARE 	Entero_Cero		INT(11);		-- Constante Entero Cero

-- ASIGNACION DE CONSTANTES
SET	Con_Principal	:= 1;
SET	Con_Foranea		:= 2;
SET	Con_NomIns		:= 3;
SET Con_Promotor	:= 4;
SET Con_MovTeso		:= 5;
SET Con_Cte			:= 6;
SET Con_Correo		:= 7;
SET Con_NumEmpleado	:= 8;
SET Est_Aplicado	:= 'A';
SET Desc_Aplicado	:= 'APLICADO';
SET Desc_Pendiente	:= 'PENDIENTE';
SET Est_Procesado	:= 'P';
SET Cadena_Vacia	:= '';
SET Entero_Cero		:= 0;
SET Con_MontoApli	:= 9;

	IF (Par_NumCon=Con_Principal) THEN
		SELECT MIN(pag.FechaAplicacion) AS FechaAplicacion ,SUM(pag.MontoPago) AS montoPagos,
				MIN(pag.Estatus) AS EstatusInst, MIN(nom.Estatus) AS EstatusDesc
			FROM DESCNOMINAREAL pag
				INNER JOIN BECARGAPAGNOMINA nom ON pag.FolioCargaID = nom.FolioCargaID
			WHERE pag.FolioCargaID = Par_FolioNum
				AND pag.EmpresaNominaID = Par_EmpresanominaID
				AND nom.Estatus = Est_Procesado
			GROUP BY pag.FolioCargaID ;
	END IF;

	IF (Par_NumCon=Con_MovTeso) THEN
		SELECT MontoMov, FechaOperacion
			FROM TESOMOVSCONCILIA
			WHERE NumeroMov = Par_FolioNum;
	END IF;

	IF(Par_NumCon = Con_MontoApli) THEN
		-- Se consulta el monto Total que se Aplico en el Folio
		SELECT MontoTotal
		INTO Var_MontoApli
		FROM DETALLEPAGNOMINST
		WHERE FolioCargaID = Par_FolioNum;

		SET Var_MontoApli := IFNULL(Var_MontoApli, Entero_Cero);

		SELECT Var_MontoApli AS MontoTotal;

	END IF;

END TerminaStore$$