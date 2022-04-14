-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPDATOSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPDATOSPRO`;DELIMITER $$

CREATE PROCEDURE `TMPDATOSPRO`(	)
TerminaStore: BEGIN

DECLARE		NumeroCliente		int;
DECLARE		Entero_Cero		int;
DECLARE		EntraCursor		int;
DECLARE		Var_Sucursal		varchar(45);
DECLARE		Var_Apell1		varchar(45);
DECLARE		Var_Apell2		varchar(45);
DECLARE		Var_Nom1			varchar(45);
DECLARE		Var_Nom2			varchar(45);
DECLARE		Var_EstadoID		varchar(45);
DECLARE 		Var_FAlta		varchar(45);
DECLARE		Var_Genero		varchar(45);
DECLARE 		Var_FNacim		varchar(45);
DECLARE		Var_EdoCivil		varchar(45);
DECLARE		Var_LugarNaci		varchar(45);
DECLARE		Var_NombreCmp		varchar(200);
DECLARE		Var_DirCmp		varchar(500);
DECLARE		Var_FechaActual	datetime;
DECLARE		Var_Fecha		date;
DECLARE		Var_NumError			int;
DECLARE		Var_ErrorMen			varchar(50);


DECLARE		CursorCliente CURSOR FOR
			(SELECT	Sucursal,	Apell1,			Apell2,
					Nom1, 		Nom2,			Estado,
					FAlta,		Genero,			FNacim,
					EdoCivil,	LugarNacimiento
			 FROM TMPDATOS);

Set Entero_Cero := 0;


		Open  CursorCliente;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			Loop
				Fetch CursorCliente  Into	Var_Sucursal, Var_Apell1,	Var_Apell2,
										Var_Nom1,	Var_Nom2,	Var_EstadoID,
										Var_FAlta,	Var_Genero,	Var_FNacim,
										Var_EdoCivil,	Var_LugarNaci	;



				Set Var_FechaActual := CURRENT_TIMESTAMP();

				Set Var_Fecha := (SELECT DATE(Var_FechaActual));

				call TMPCLIENTESALT (convert(Var_Sucursal,unsigned), 'M', 'Lic.',
								Var_Nom1,	Var_Nom2, '', 	Var_Apell1,	Var_Apell2,
								STR_TO_DATE(Var_FNacim, '%d/%m/%Y'), 700,	Var_EstadoID,
								'N',	700,	 Var_Genero,	'JILSO880905MOCN0',	'JILS880905MF8',
								Var_EdoCivil,	'87654321','12345678','yupi@hotmail.com',
								'Desarrollos Orientados a Eficiencia SA de CV.',
								6,	 ' ', 15, '12345678',	0,	' ',		'casa',	0.0, ' ',
								'S',1, 'N', 'S','S', 'B', 30,	0112037010,	01001,	14, 1,	2,
								' ', ' ',
								1, 10, Var_FechaActual, '0:0:0:0:0:0:0:1', ' ',
								convert(Var_Sucursal,unsigned), 0,
								NumeroCliente, Var_NumError, Var_ErrorMen, Var_NombreCmp
										);

				if(Var_NumError = Entero_Cero)then
					  call TMPDIRCLIENTALT (NumeroCliente, 1, Var_EstadoID, 67,
											'PRIVADA DE MONTE CRISTO', '105', '', '',
											'AV. LA PAZ Y MONTE CARLO',
											'MONTE BLANCO Y CARRETERA MONTE ALBAN',
											'LOMAS DE SAN JUAN CHAPULTEPEC',	68150,
											'casa blanca', 17.082733, -96.741453, 'S',
											1, 10, Var_FechaActual, '0:0:0:0:0:0:0:1', ' ',
											convert(Var_Sucursal,unsigned), 0,
											Var_DirCmp, Var_NumError, Var_ErrorMen
											);

							if(Var_NumError > 0) then
								insert into BITACORADIRCLI values (NumeroCliente, 1, 1, 1,Var_EstadoID, 67,
											'PRIVADA DE MONTE CRISTO', '105', '', '',
											'AV. LA PAZ Y MONTE CARLO',
											'MONTE BLANCO Y CARRETERA MONTE ALBAN',
											'LOMAS DE SAN JUAN CHAPULTEPEC',	68150,
											Var_DirCmp,'casa blanca', 17.082733, -96.741453,
											'S',
											 10, Var_FechaActual, '0:0:0:0:0:0:0:1', ' ',
											convert(Var_Sucursal,unsigned), 0,
											'TMPDIRCLIENTALT',Var_NumError, Var_ErrorMen
											);
							end if;
					else

						insert into BITACORACLIENTES values (NumeroCliente, 1, convert(Var_Sucursal,unsigned), 'M', 'Lic.',
								Var_Nom1,	Var_Nom2, ' ', 	Var_Apell1,	Var_Apell2,
								STR_TO_DATE(Var_FNacim, '%d/%m/%Y'),'JILSO880905MOCN0','N',700,15,
								'Desarrollos Orientados a Eficiencia SA de CV.', 6, '12345678',
								'yupi@hotmail.com', 'JILS880905MF8',' ', 30, 0112037010, 01001,
								14,	Var_Genero, Var_EdoCivil, 700,Var_EstadoID, 0, 'casa',
								0, '', 1.0, '87654321','12345678','S',1, 'N', 'S','S', 'B', 1, 2,
								Var_Fecha, 'A', Var_NombreCmp, ' ', ' ',
								 10, Var_FechaActual, '0:0:0:0:0:0:0:1', ' ',
								convert(Var_Sucursal,unsigned), 0 , 'TMPCLIENTESALT',Var_NumError, Var_ErrorMen
										);


				end if;



			End Loop;
		END;
		Close CursorCliente;


END TerminaStore$$