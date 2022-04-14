package guardaValores.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import general.dao.BaseDAO;
import guardaValores.bean.CatOrigenesDocumentosBean;
import herramientas.Constantes;
import herramientas.Utileria;

public class CatOrigenesDocumentosDAO extends BaseDAO {

	public CatOrigenesDocumentosDAO(){
		super();
	}
	
	// Consulta Principal
	public CatOrigenesDocumentosBean consultaPrincipal(final CatOrigenesDocumentosBean catOrigenesDocumentosBean, final int tipoConsulta) {

		CatOrigenesDocumentosBean catOrigenesDocumentos = null;
		//Query con el Store Procedure
		try{
			String query = "CALL CATORIGENESDOCUMENTOSCON(?,?,"
														+"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteEntero(catOrigenesDocumentosBean.getCatOrigenDocumentoID()),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CatOrigenesDocumentosDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"CALL CATORIGENESDOCUMENTOSCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CatOrigenesDocumentosBean catalogo = new CatOrigenesDocumentosBean();

					catalogo.setCatOrigenDocumentoID(resultSet.getString("CatOrigenDocumentoID"));
					catalogo.setNombreOrigen(resultSet.getString("NombreOrigen"));
					catalogo.setDescripcion(resultSet.getString("Descripcion"));
					catalogo.setEstatus(resultSet.getString("Estatus"));
					return catalogo;
				}
			});

			catOrigenesDocumentos = matches.size() > 0 ? (CatOrigenesDocumentosBean) matches.get(0) : null;

		}catch (Exception exception) {
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta principal del Catálogo de Origenes de Guarda Valores ", exception);
			catOrigenesDocumentos = null;
		}

		return catOrigenesDocumentos;
	}

	// Consulta Principal
	public CatOrigenesDocumentosBean consultaCatalogoActivo(final CatOrigenesDocumentosBean catOrigenesDocumentosBean, final int tipoConsulta) {

		CatOrigenesDocumentosBean catalogoInstrumentos = null;
		//Query con el Store Procedure
		try{
			String query = "CALL CATORIGENESDOCUMENTOSCON(?,?,"
														+"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteEntero(catOrigenesDocumentosBean.getCatOrigenDocumentoID()),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CatOrigenesDocumentosDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"CALL CATORIGENESDOCUMENTOSCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CatOrigenesDocumentosBean catalogo = new CatOrigenesDocumentosBean();

					catalogo.setCatOrigenDocumentoID(resultSet.getString("CatOrigenDocumentoID"));
					catalogo.setNombreOrigen(resultSet.getString("NombreOrigen"));
					catalogo.setDescripcion(resultSet.getString("Descripcion"));
					catalogo.setEstatus(resultSet.getString("Estatus"));
					return catalogo;
				}
			});

			catalogoInstrumentos = matches.size() > 0 ? (CatOrigenesDocumentosBean) matches.get(0) : null;

		}catch (Exception exception) {
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta del Catálogo de Origenes Activos de Guarda Valores ", exception);
			catalogoInstrumentos = null;
		}

		return catalogoInstrumentos;
	}
	
	// Lista Instrumentos
	public List<CatOrigenesDocumentosBean> listaPrincipal(final CatOrigenesDocumentosBean catOrigenesDocumentosBean, final int tipoLista) {

		List<CatOrigenesDocumentosBean> listaOrigen = null;
		//Query con el Store Procedure
		try{
			String query = "CALL CATORIGENESDOCUMENTOSLIS(?,?,?,"
														+"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteEntero(catOrigenesDocumentosBean.getCatOrigenDocumentoID()),
				catOrigenesDocumentosBean.getNombreOrigen(),
				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CatOrigenesDocumentosDAO.listaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL CATORIGENESDOCUMENTOSLIS(" + Arrays.toString(parametros) + ")");
			List<CatOrigenesDocumentosBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CatOrigenesDocumentosBean  catalogo = new CatOrigenesDocumentosBean();

					catalogo.setCatOrigenDocumentoID(resultSet.getString("CatOrigenDocumentoID"));
					catalogo.setNombreOrigen(resultSet.getString("NombreOrigen"));
					catalogo.setDescripcion(resultSet.getString("Descripcion"));
					catalogo.setEstatus(resultSet.getString("Estatus"));
					return catalogo;
				}
			});

			listaOrigen = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista del Catálogo de Origenes de Guarda Valores", exception);
			listaOrigen = null;
		}

		return listaOrigen;
	}

	// Lista Combo
	public List<CatOrigenesDocumentosBean> listaCombo(final int tipoLista) {

		List listaOrigen = null;
		//Query con el Store Procedure
		try{
			String query = "CALL CATORIGENESDOCUMENTOSLIS(?,?,?,"
														+"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Constantes.ENTERO_CERO,
				Constantes.STRING_VACIO,
				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CatOrigenesDocumentosDAO.listaCombo",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL CATORIGENESDOCUMENTOSLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CatOrigenesDocumentosBean  catalogo = new CatOrigenesDocumentosBean();

					catalogo.setCatOrigenDocumentoID(resultSet.getString("CatOrigenDocumentoID"));
					catalogo.setNombreOrigen(resultSet.getString("NombreOrigen"));
					catalogo.setDescripcion(resultSet.getString("Descripcion"));
					catalogo.setEstatus(resultSet.getString("Estatus"));
					return catalogo;
				}
			});

			listaOrigen = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista Combo de Origen de Documentos de Guarda Valores", exception);
			listaOrigen = null;
		}

		return listaOrigen;
	}
	
	// Lista Origenes Pantalla
	public List<CatOrigenesDocumentosBean> listaFiltrado(final CatOrigenesDocumentosBean catOrigenesDocumentosBean, final int tipoLista) {

		List<CatOrigenesDocumentosBean> listaOrigenes = null;
		//Query con el Store Procedure
		try{
			String query = "CALL CATORIGENESDOCUMENTOSLIS(?,?,?,"
														+"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteEntero(catOrigenesDocumentosBean.getCatOrigenDocumentoID()),
				catOrigenesDocumentosBean.getNombreOrigen(),
				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CatOrigenesDocumentosDAO.listaFiltrado",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL CATORIGENESDOCUMENTOSLIS(" + Arrays.toString(parametros) + ")");
			List<CatOrigenesDocumentosBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CatOrigenesDocumentosBean  catalogo = new CatOrigenesDocumentosBean();

					catalogo.setCatOrigenDocumentoID(resultSet.getString("CatOrigenDocumentoID"));
					catalogo.setDescripcion(resultSet.getString("Descripcion"));
					catalogo.setEstatus(resultSet.getString("Estatus"));
					return catalogo;
				}
			});

			listaOrigenes = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de Instrumentos (Pantalla) de Guarda Valores", exception);
			listaOrigenes = null;
		}

		return listaOrigenes;
	}
	
	// Lista Instrumentos Activos en pantalla
	public List<CatOrigenesDocumentosBean> listaFiltradoActivo(final CatOrigenesDocumentosBean catOrigenesDocumentosBean, final int tipoLista) {

		List<CatOrigenesDocumentosBean> listaInstrumentos = null;
		//Query con el Store Procedure
		try{
			String query = "CALL CATORIGENESDOCUMENTOSLIS(?,?,?,"
														+"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteEntero(catOrigenesDocumentosBean.getCatOrigenDocumentoID()),
				catOrigenesDocumentosBean.getNombreOrigen(),
				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CatOrigenesDocumentosDAO.listaFiltradoActivo",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL CATORIGENESDOCUMENTOSLIS(" + Arrays.toString(parametros) + ")");
			List<CatOrigenesDocumentosBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CatOrigenesDocumentosBean  catalogo = new CatOrigenesDocumentosBean();

					catalogo.setCatOrigenDocumentoID(resultSet.getString("CatOrigenDocumentoID"));
					catalogo.setDescripcion(resultSet.getString("Descripcion"));
					return catalogo;
				}
			});

			listaInstrumentos = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de Origenes Activos (Pantalla) de Guarda Valores", exception);
			listaInstrumentos = null;
		}

		return listaInstrumentos;
	}
		
}
