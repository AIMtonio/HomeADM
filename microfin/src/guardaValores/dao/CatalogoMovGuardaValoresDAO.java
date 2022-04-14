package guardaValores.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import general.dao.BaseDAO;
import guardaValores.bean.CatalogoMovGuardaValoresBean;
import herramientas.Constantes;
import herramientas.Utileria;

public class CatalogoMovGuardaValoresDAO extends BaseDAO {
	
	public CatalogoMovGuardaValoresDAO(){
		super();
	}
	
	// Consulta Principal
	public CatalogoMovGuardaValoresBean consultaPrincipal(final CatalogoMovGuardaValoresBean catalogoMovGuardaValoresBean, final int tipoConsulta) {

		CatalogoMovGuardaValoresBean catalogoMovGuardaValores = null;
		//Query con el Store Procedure
		try{
			String query = "CALL CATMOVDOCGRDVALORESCON(?,?,"
													+"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteEntero(catalogoMovGuardaValoresBean.getCatMovimientoID()),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CatalogoMovGuardaValoresDAO.consulta",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"CALL CATMOVDOCGRDVALORESCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CatalogoMovGuardaValoresBean catalogo = new CatalogoMovGuardaValoresBean();
					catalogo.setCatMovimientoID(resultSet.getString("CatMovimientoID"));
					catalogo.setNombreMovimiento(resultSet.getString("NombreMovimiento"));
					catalogo.setDescripcion(resultSet.getString("Descripcion"));
					catalogo.setEstatus(resultSet.getString("Estatus"));
					return catalogo;
				}
			});

			catalogoMovGuardaValores = matches.size() > 0 ? (CatalogoMovGuardaValoresBean) matches.get(0) : null;

		}catch (Exception exception) {
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta de Movimientos de Guarda Valores ", exception);
			catalogoMovGuardaValores = null;
		}

		return catalogoMovGuardaValores;
	}
	
	// Lista Instrumentos
	public List<CatalogoMovGuardaValoresBean> listaPrincipal(final CatalogoMovGuardaValoresBean catalogoMovGuardaValoresBean, final int tipoLista) {

		List<CatalogoMovGuardaValoresBean> listaInstrumentos = null;
		//Query con el Store Procedure
		try{
			String query = "CALL CATMOVDOCGRDVALORESLIS(?,?,?,"
													+"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteEntero(catalogoMovGuardaValoresBean.getCatMovimientoID()),
				catalogoMovGuardaValoresBean.getNombreMovimiento(),
				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CatalogoMovGuardaValoresDAO.listaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL CATMOVDOCGRDVALORESLIS(" + Arrays.toString(parametros) + ")");
			List<CatalogoMovGuardaValoresBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CatalogoMovGuardaValoresBean  catalogo = new CatalogoMovGuardaValoresBean();

					catalogo.setCatMovimientoID(resultSet.getString("CatMovimientoID"));
					catalogo.setNombreMovimiento(resultSet.getString("NombreMovimiento"));
					catalogo.setDescripcion(resultSet.getString("Descripcion"));
					catalogo.setEstatus(resultSet.getString("Estatus"));
					
					return catalogo;
				}
			});

			listaInstrumentos = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de Movimientos de Guarda Valores", exception);
			listaInstrumentos = null;
		}

		return listaInstrumentos;
	}

	// Lista Instrumentos Activos
	public List listaComboPantalla(final int tipoLista) {

		List listaInstrumentos = null;
		//Query con el Store Procedure
		try{
			String query = "CALL CATMOVDOCGRDVALORESLIS(?,?,?,"
													+"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Constantes.ENTERO_CERO,
				Constantes.STRING_VACIO,
				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CatalogoMovGuardaValoresDAO.listaComboPantalla",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL CATMOVDOCGRDVALORESLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CatalogoMovGuardaValoresBean  catalogo = new CatalogoMovGuardaValoresBean();

					catalogo.setCatMovimientoID(resultSet.getString("CatMovimientoID"));
					catalogo.setNombreMovimiento(resultSet.getString("NombreMovimiento"));
					catalogo.setDescripcion(resultSet.getString("Descripcion"));
					catalogo.setEstatus(resultSet.getString("Estatus"));
					
					return catalogo;
				}
			});

			listaInstrumentos = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de Movimientos  Activos para Pantalla de Guarda Valores", exception);
			listaInstrumentos = null;
		}

		return listaInstrumentos;
	}
}