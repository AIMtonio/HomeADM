-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DISPERSIONMOVCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `DISPERSIONMOVCON`;
DELIMITER $$

CREATE PROCEDURE `DISPERSIONMOVCON`(
# ============================================================
# ---- SP PARA CONSULTAR LOS DETALLES DE LAS DISPERSIONES-----
# ============================================================
    Par_DispersionID     	INT(11),
    Par_InstitucionID	 	INT(11),
	Par_ClaveDispMov		INT(11),
    Par_NumLis           	TINYINT UNSIGNED,

	Aud_EmpresaID			INT(11),
    Aud_Usuario				INT(11),
    Aud_FechaActual			DATETIME,
    Aud_DireccionIP			VARCHAR(15),
    Aud_ProgramaID			VARCHAR(50),
    Aud_Sucursal			INT(11),
    Aud_NumTransaccion		BIGINT(20)
	)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Lis_Principal	INT(11);
	DECLARE Var_Exporta 	INT(11);
	DECLARE Var_Autoriza 	INT(11);
	DECLARE Var_Cancela		INT(11);
	DECLARE Var_SiEnvia 	CHAR(1);
	DECLARE Est_Autoriz		CHAR(1); -- Estatus Autorizado
	DECLARE Est_NoAplic		CHAR(1); -- Estatus No Aplicado
	DECLARE Est_PenAuto		CHAR(1); -- Estatus Pendiente por Autorizar,
	DECLARE TipoMovSpei		CHAR(4); -- SPEI por Desembolso de Credito corresponde con la tabla TIPOSMOVTESO
	DECLARE Var_iva			DECIMAL(12,4);
    DECLARE Cli_Esp			INT(11);
    DECLARE Cli_EspCred		INT(11);
	DECLARE TipoMovOrden 	VARCHAR(50);

    DECLARE CliProcEspecifico	VARCHAR(20);

	-- Asignacion de Constantes
	SET TipoMovOrden 		:= '';
	SET Est_Autoriz 		:= 'A'; -- Estatus Autorizado
	SET Est_NoAplic 		:= 'N'; -- Estatus No Aplicado
	SET Est_PenAuto 		:= 'P'; -- Estatus Pendiente por Autorizar,
	SET Lis_Principal		:= 1;
	SET Var_Exporta			:= 2;
	SET Var_Autoriza		:= 3;
	SET Var_Cancela			:= 4;
	SET Var_SiEnvia			:= 'S';
	SET Var_iva				:= 0.0000;
	SET TipoMovSpei			:= '2'; -- SPEI por Desembolso de Credito corresponde con la tabla TIPOSMOVTESO
    SET Cli_EspCred			:= 24;
    SET CliProcEspecifico	:='CliProcEspecifico';
    SET Cli_Esp				:=(SELECT ValorParametro  FROM PARAMGENERALES WHERE LlaveParametro= CliProcEspecifico);


	IF(Par_NumLis = Lis_Principal) THEN

		SELECT		ClaveDispMov,	CuentaCargo ,		Descripcion ,		Referencia ,
					TipoMovDIspID,  FormaPago,			Monto ,				CuentaDestino,
					NombreBenefi,	FechaEnvio,			Identificacion ,	Estatus
			FROM	DISPERSIONMOV
			WHERE 	DispersionID = 	Par_DispersionID AND
					Estatus 		IN (Est_NoAplic);
	END IF;

	IF(Par_NumLis = Var_Exporta) THEN

		SELECT		ClaveDispMov,	DispersionID,	CuentaCargo,	Descripcion,		Referencia,
					TipoMovDIspID,	Monto,			CuentaDestino,	Identificacion,		Estatus,
					NombreBenefi,	DATE_FORMAT(FechaEnvio, '%Y-%m-%d')AS FechaEnvio,	Var_iva
			FROM   	DISPERSIONMOV
			WHERE  	DispersionID 	= Par_DispersionID
			AND		Estatus 		= Est_Autoriz
			AND 	TipoMovDIspID 	IN('2','3','5','15','21','22','103') ;


	END IF;

	IF(Par_NumLis = Var_Autoriza) THEN
		IF(Cli_Esp = Cli_EspCred) THEN

			SELECT   	mov.ClaveDispMov,		mov.CuentaCargo,		mov.CuentaContable,	 Cta.Descripcion AS CtaContDescrip,
						mov.Descripcion,	 	mov.Referencia,			mov.TipoMovDIspID, 	 mov.FormaPago,		 mov.Monto,
						mov.NombreBenefi,		mov.FechaEnvio,		 	mov.Identificacion, 	mov.Estatus,
						dis.InstitucionID, 		dis.NumCtaInstit,       mov.Sucursal,        mov.Usuario,		 mov.TipoChequera,
						mov.ConceptoDispersion,
                        CASE mov.FormaPago WHEN 5 THEN CASE SUBSTRING(mov.CuentaDestino,1,2) WHEN 71 THEN SUBSTRING(mov.CuentaDestino,1,13) ELSE mov.CuentaDestino END
							ELSE mov.CuentaDestino 
						END AS CuentaDestino
				FROM	DISPERSIONMOV mov
						INNER JOIN	DISPERSION dis	ON 	dis.FolioOperacion 	= mov.DispersionID
													AND mov.DispersionID 	= Par_DispersionID
						LEFT  JOIN CUENTASCONTABLES Cta	ON  Cta.CuentaCompleta  = mov.CuentaContable
					    WHERE mov.Estatus = Est_PenAuto ORDER BY mov.Referencia ASC;

		ELSE
			SELECT   	mov.ClaveDispMov,		mov.CuentaCargo,		mov.CuentaContable,	 Cta.Descripcion AS CtaContDescrip,
						mov.Descripcion,	 	mov.Referencia,			mov.TipoMovDIspID, 	 mov.FormaPago,		 mov.Monto,
						mov.NombreBenefi,		mov.FechaEnvio,		 	mov.Identificacion,  mov.Estatus,
						dis.InstitucionID, 		dis.NumCtaInstit,       mov.Sucursal,        mov.Usuario,		 mov.TipoChequera,
						mov.ConceptoDispersion,
                         CASE mov.FormaPago WHEN 5 THEN CASE SUBSTRING(mov.CuentaDestino,1,2) WHEN 71 THEN SUBSTRING(mov.CuentaDestino,1,13) ELSE mov.CuentaDestino END
							ELSE mov.CuentaDestino 
						END AS CuentaDestino
				FROM	DISPERSIONMOV mov
						INNER JOIN	DISPERSION dis	ON 	dis.FolioOperacion 	= mov.DispersionID
													AND mov.DispersionID 	= Par_DispersionID
						LEFT  JOIN CUENTASCONTABLES Cta	ON  Cta.CuentaCompleta  = mov.CuentaContable;
		END IF;

	END IF;

	IF(Par_NumLis = Var_Cancela) THEN

		SELECT   	mov.ClaveDispMov,		mov.CuentaCargo,		mov.CuentaContable,	 Cta.Descripcion AS CtaContDescrip,
					mov.Descripcion,	 	mov.Referencia,			mov.TipoMovDIspID, 	 mov.FormaPago,		 mov.Monto,
					mov.CuentaDestino,   	mov.NombreBenefi,		mov.FechaEnvio,		 mov.Identificacion, mov.Estatus,
					dis.InstitucionID, 		dis.NumCtaInstit,       mov.Sucursal,        mov.Usuario
		FROM 		DISPERSIONMOV mov
					INNER JOIN	DISPERSION dis	ON	dis.FolioOperacion 	= mov.DispersionID
												AND mov.DispersionID 	= Par_DispersionID
												AND	mov.ClaveDispMov 	= Par_ClaveDispMov
					LEFT  JOIN CUENTASCONTABLES Cta	ON Cta.CuentaCompleta  = mov.CuentaContable;
	END IF;

END TerminaStore$$