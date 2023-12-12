import express from 'express'
import { execSync } from 'child_process'
import cors from 'cors'

export const segment = (text: string) => {
  try {
    return JSON.parse(
      execSync(
        `cd /root/quicklisp/local-projects/ichiran/ && ./ichiran-cli -f -- "${text}"`
      ).toString()
    )
  } catch (e) {
    console.error(e)
    return []
  }
}
;(async () => {
  //await build();

  const app = express()
  app.use(cors())
  app.use(express.json())
  app.post('/segmentation', (req, res) => {
    if (req.body.text && req.body.text.length > 0) {
      res.json(segment(req.body.text))
    } else {
      res.status(500)
      res.send()
    }
  })

  // Use PORT provided in environment or default to 3000
  const portEnv = process.env.PORT
  const port = portEnv ? parseInt(portEnv) : 3000

  // Listen on `port` and 0.0.0.0
  app.listen(port, '0.0.0.0', function () {
    console.log(`Server started on port ${port}!`)
  })
})()
