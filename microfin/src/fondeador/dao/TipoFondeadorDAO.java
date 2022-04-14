package fondeador.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import fondeador.bean.TipoFondeadorBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class TipoFondeadorDAO extends BaseDAO {
	public TipoFondeadorDAO() {
		super();
	}
	

	/* Lista de Tipos de Fondeadores Activos e inactivos  */
	public List listaPrincipal(TipoFondeadorBean tipoFondeadorBean, int tipoLista) {
		List tiposFondeadores = null;
		//Query con el Store Procedure
		try {
			String query = "call CATFONDEADORESLIS(?,?,?,?,?, ?,?,?,?);";
						Object[] parametros = {	tipoFondeadorBean.getDesTipoFondeador(),
												tipoLista,
												Constantes.ENTERO_CERO,
												Constantes.ENTERO_CERO,
												Constantes.FECHA_VACIA,
												Constantes.STRING_VACIO,
												"TipoFondeadorDAO.listaPrincipal",
												Constantes.ENTERO_CERO,
												Constantes.ENTERO_CERO};
						loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATFONDEADORESLIS(" +Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TipoFondeadorBean institutFondeo = new TipoFondeadorBean();
					institutFondeo.setCatFondeadorID(resultSet.getString("CatFondeadorID"));
					institutFondeo.setDesTipoFondeador(resultSet.getString("Descripcion"));
			
					return institutFondeo;			
				}
			});
			tiposFondeadores =	matches;
		}catch(Exception e){
			e.printStackTrace();
		}	
		return tiposFondeadores;
	}	
	
	/* Lista Combo de Tipos de Fondeadores Activos*/
	public List listaComboTiposFondAct(int tipoLista) {
		List tiposFondeadores = null;
		//Query con el Store Procedure
		try {
			String query = "call CATFONDEADORESLIS(?,?,?,?,?, ?,?,?,?);";
						Object[] parametros = {	Constantes.STRING_VACIO,
												tipoLista,
												Constantes.ENTERO_CERO,
												Constantes.ENTERO_CERO,
												Constantes.FECHA_VACIA,
												Constantes.STRING_VACIO,
												"TipoFondeadorDAO.listaCombo",
												Constantes.ENTERO_CERO,
												Constantes.ENTERO_CERO};
						loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATFONDEADORESLIS(" +Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TipoFondeadorBean institutFondeo = new TipoFondeadorBean();
					institutFondeo.setTipoFondeador(resultSet.getString("TipoFondeador"));
					institutFondeo.setDesTipoFondeador(resultSet.getString("Descripcion"));
			
					return institutFondeo;			
				}
			});
			tiposFondeadores =	matches;
		}catch(Exception e){
			e.printStackTrace();
		}	
		return tiposFondeadores;
	}	
	
	//consulta de Productos de credito
	public TipoFondeadorBean consultaPrincipal(TipoFondeadorBean tipoFondeadorBean, int tipoConsulta) {
		TipoFondeadorBean TipoFondeador = new TipoFondeadorBean();
		try{
			//Query con el Store Procedure
			String query = "call CATFONDEADORESCON(?,? ,?,?,?,?,?,?,?);";
			Object[] parametros = { Utileria.convierteEntero(tipoFondeadorBean.getCatFondeadorID()),
									tipoConsulta,
									
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"TipoFondeadorDAO.consultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PRODUCTOSCREDITOCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TipoFondeadorBean tipoFond = new TipoFondeadorBean();
					tipoFond.setTipoFondeador(resultSet.getString("TipoFondeador"));
					tipoFond.setDesTipoFondeador(resultSet.getString("Descripcion"));
					tipoFond.setEstatus(resultSet.getString("Estatus"));

					return tipoFond;
				}
			});
		TipoFondeador =  matches.size() > 0 ? (TipoFondeadorBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
		}
		return TipoFondeador;
	}	
}
