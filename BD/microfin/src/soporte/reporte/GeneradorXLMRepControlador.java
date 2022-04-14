package soporte.reporte;

import general.bean.ParametrosSesionBean;
import herramientas.Utileria;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.stream.XMLEventFactory;
import javax.xml.stream.XMLEventWriter;
import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.events.Attribute;
import javax.xml.stream.events.Characters;
import javax.xml.stream.events.EndElement;
import javax.xml.stream.events.StartDocument;
import javax.xml.stream.events.StartElement; import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.GeneradorXMLBean;
import soporte.bean.GeneradorXMLEtiquetasBean;
import soporte.dao.GeneradorXLMDAO.Enum_Con_Reporte;
import soporte.servicio.GeneradorXLMServicio;
import soporte.servicio.ParametrosSisServicio;

/**
 * Clase para generar dinamicamente los reportes en XLM, si el diseño de tu reporte tiene otros detalles es preferible que crees sus propias clases, esta clase es para el diseño estandar.
 * 
 * @author pmontero
 * @version 1.0.0
 */
public class GeneradorXLMRepControlador extends AbstractCommandController {
	GeneradorXLMServicio generadorXLMServicio;
	String successView = null;
	ParametrosSesionBean parametrosSesionBean = null;
	ParametrosSisServicio parametrosSisServicio = null;

	public GeneradorXLMRepControlador() {
		setCommandClass(GeneradorXMLBean.class);
		setCommandName("generadorXMLBean");
	}

	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		GeneradorXMLBean bean = (GeneradorXMLBean) command;
		String htmlString = "";
		try {
			int tipoReporte = Utileria.convierteEntero(request.getParameter("tipoReporte"));
			reporteXLM(bean, request, response);
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return new ModelAndView(getSuccessView(), "reporte", htmlString);
	}

	private void reporteXLM(GeneradorXMLBean bean, HttpServletRequest request, HttpServletResponse response) {
		String htmlString="";
		try {
			Calendar calendario = new GregorianCalendar();
			SimpleDateFormat postFormater = new SimpleDateFormat("HH:mm");
			String hora = postFormater.format(calendario.getTime());
			GeneradorXMLBean encabezadoBean = generadorXLMServicio.encabezado(bean, Enum_Con_Reporte.ENCABEZADO);
			bean.setParametros(generadorXLMServicio.getParametros(bean));
			bean.setEtiquetas(generadorXLMServicio.getEtiquetas(bean));
			bean.setFilas(generadorXLMServicio.getFilas(bean));
			List<GeneradorXMLEtiquetasBean> etiquetas = generadorXLMServicio.getEtiquetas(bean);
			List<List<String>> datosReporte = generadorXLMServicio.getFilas(bean);

			/****************************************** CREACION DEL ARCHIVO XML *************************************************** */
			String directorio = bean.getRutaRep();
			String archivo = directorio+bean.getNombreArchivo().replace(" ", "_") + bean.getExtension();
			String NombreXML= bean.getNombreArchivo().replace(" ", "_") + bean.getExtension();

			System.out.println("archivo:\n"+archivo);
			boolean exists = (new File(directorio)).exists();
			if (!exists) {
				File aDir = new File(directorio);
				aDir.mkdirs();
			}

			// create and write Start Tag
			DocumentBuilder builder = null;

			try {
				builder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
			} catch (ParserConfigurationException e) {
				throw e;
			}
			Document document = builder.newDocument();

			// Se crea el elemento root.
			Element root = document.createElement(encabezadoBean.getElementoRoot());
			// Se agrega al documento.
			document.appendChild(root);
			Element nodo = null;
			Element nodo2 = null;
			Element nodo3 = null;
			Element nodo4 = null;

			
			for(int datos = 0; datos < datosReporte.size(); datos++){
				 																							// <archivo>
				for(int i = 0; i<bean.getEtiquetas().size();i++){
					// Se crea un elemento nodo si es tipo 1, y se agrega al elemento root.
					if(etiquetas.get(i).getTipo() == 1 && etiquetas.get(i).getNivel() == 1){
						nodo = document.createElement(etiquetas.get(i).getEtiqueta());
						root.appendChild(nodo);																// <organo_supervisor>
					}else if (etiquetas.get(i).getTipo() != 1  && etiquetas.get(i).getNivel() == 1){
						// Se crea un elemento nuevo con su respectivo valor.
						Element nodoValor = document.createElement(etiquetas.get(i).getEtiqueta());
						nodoValor.setTextContent(datosReporte.get(datos).get(i));							// <tipo_itf>
						// Se agrega al nodo.
						nodo.appendChild(nodoValor);
					}else{
						if(etiquetas.get(i).getTipo() == 1 && etiquetas.get(i).getNivel() == 2){
							nodo2 = document.createElement(etiquetas.get(i).getEtiqueta());
							nodo.appendChild(nodo2);
						}else if (etiquetas.get(i).getTipo() != 1  && etiquetas.get(i).getNivel() == 2){
							// Se crea un elemento nuevo con su respectivo valor.
							Element nodoValor = document.createElement(etiquetas.get(i).getEtiqueta());
							nodoValor.setTextContent(datosReporte.get(datos).get(i));
							// Se agrega al nodo.
							nodo2.appendChild(nodoValor);
						}else{
							if(etiquetas.get(i).getTipo() == 1 && etiquetas.get(i).getNivel() == 3){
								nodo3 = document.createElement(etiquetas.get(i).getEtiqueta());
								nodo2.appendChild(nodo3);
							}else if (etiquetas.get(i).getTipo() != 1  && etiquetas.get(i).getNivel() == 3){
								// Se crea un elemento nuevo con su respectivo valor.
								Element nodoValor = document.createElement(etiquetas.get(i).getEtiqueta());
								nodoValor.setTextContent(datosReporte.get(datos).get(i));
								// Se agrega al nodo.
								nodo3.appendChild(nodoValor);
							}else{
								if(etiquetas.get(i).getTipo() == 1 && etiquetas.get(i).getNivel() == 4){
									nodo4 = document.createElement(etiquetas.get(i).getEtiqueta());
									nodo3.appendChild(nodo4);
								}else if (etiquetas.get(i).getTipo() != 1  && etiquetas.get(i).getNivel() == 4){
									// Se crea un elemento nuevo con su respectivo valor.
									Element nodoValor = document.createElement(etiquetas.get(i).getEtiqueta());
									nodoValor.setTextContent(datosReporte.get(datos).get(i));
									// Se agrega al nodo.
									nodo4.appendChild(nodoValor);
								}else{
									
								}//fin 4
							}//fin 3
						}//fin 2
					}
					//fin 1
				}
			}
			Transformer transformer;
			try {
				TransformerFactory transformerFactory = TransformerFactory.newInstance();
				transformer = transformerFactory.newTransformer();
				File archivoFile = new File(archivo);
				Result output = new StreamResult(archivoFile);
				Source input = new DOMSource(document);
				// if you want xml to be properly formatted
				transformer.setOutputProperty(OutputKeys.INDENT, "yes");
				transformer.transform(input, output);
				FileInputStream fileInputStream = new FileInputStream(archivoFile);
				response.addHeader("Content-Disposition", "attachment; filename=" + NombreXML);
				response.setContentType("application/xml");
				  response.setContentLength((int) archivoFile.length());
					
				  int bytes;
				
				  while ((bytes = fileInputStream.read()) != -1) {
					response.getOutputStream().write(bytes);
				  }
				  fileInputStream.close();
				response.getOutputStream().flush();
				response.getOutputStream().close();
			} catch (TransformerConfigurationException e) {
				throw e;
			} catch (TransformerException e) {
				throw e;
			}
			/************************************************ FIN ARCHIVO ******************************************** */
		} catch (Exception ex) {
			ex.printStackTrace();

		}
		//	return new ModelAndView("resultadoTransaccionReporteVista", "reporte", htmlString);

	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}

	public GeneradorXLMServicio getGeneradorXLMServicio() {
		return generadorXLMServicio;
	}

	public void setGeneradorXLMServicio(GeneradorXLMServicio generadorXLMServicio) {
		this.generadorXLMServicio = generadorXLMServicio;
	}
}
